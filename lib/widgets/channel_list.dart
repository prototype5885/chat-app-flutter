import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/widgets/channel.dart';
import 'package:chat_app_flutter/widgets/top.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio_client.dart';

class ChannelList extends StatefulWidget {
  final bool isDemo;
  final String serverID;

  const ChannelList({super.key, required this.isDemo, required this.serverID});

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late Future<void> loaded;
  late List<ChannelModel> channelList = [];

  @override
  void initState() {
    if (widget.isDemo) {
      channelList = List.generate(50, (index) {
        final serverNumber = index + 1;
        return ChannelModel(
          id: serverNumber.toString(),
          serverID: '0',
          name: "Channel $serverNumber",
        );
      });
      loaded = Future.value();
    } else {
      loaded = fetchChannels();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchChannels() async {
    try {
      log("Fetching channels for server ID ${widget.serverID}...");
      final response = await dioClient.dio.get(
        '/api/channel/fetch',
        queryParameters: {"serverID": widget.serverID},
      );
      final List<dynamic> rawList = jsonDecode(response.data);

      setState(() {
        channelList = rawList
            .map(
              (jsonMap) =>
                  ChannelModel.fromJson(jsonMap as Map<String, dynamic>),
            )
            .toList();
      });

      if (channelList.isNotEmpty) {
        state.currentChannel.value = channelList.first.id;
      } else {
        state.currentChannel.value = "none";
      }
    } on DioException catch (e) {
      debugPrint('$e');
      setState(() {
        if (e.type == DioExceptionType.connectionError) {
          // _loggedInText = lang.serverOffline;
        } else if (e.type == DioExceptionType.badResponse) {
          // _loggedInText = lang.notLoggedIn;
        } else {
          // _loggedInText = e.type.toString();
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  void selectChannel(String channelID) {
    log("Selected channel ID $channelID");
    if (channelList.isNotEmpty) {
      ChannelModel channel = channelList.firstWhere(
        (server) => server.id == channelID,
      );
      setState(() {
        state.currentChannel.value = channel.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Top(childWidget: Text(widget.serverID)),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: FutureBuilder(
              future: loaded,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: channelList.length,
                      itemBuilder: (context, index) {
                        final channel = channelList[index];
                        return Channel(
                          key: ValueKey(channel.name),
                          id: channel.id,
                          name: channel.name,
                          selected: channel.id == state.currentChannel.value,
                          onClicked: selectChannel,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
