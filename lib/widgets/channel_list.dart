import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/models.dart';
import 'package:chat_app_flutter/state.dart' as state;
import 'package:chat_app_flutter/widgets/channel.dart';
import 'package:chat_app_flutter/widgets/delayed_loading_indicator.dart';
import 'package:chat_app_flutter/widgets/message_area.dart';
import 'package:chat_app_flutter/widgets/top.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../dio_client.dart';
import '../macros.dart';

class ChannelList extends StatefulWidget {
  final String currentServerID;

  const ChannelList({super.key, required this.currentServerID});

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  String currentChannelID = "";

  late Future<void> channelListLoaded;
  late List<ChannelModel> channelList = [];

  @override
  void initState() {
    if (state.demo.value) {
      channelList = List.generate(50, (index) {
        final serverNumber = index + 1;
        return ChannelModel(
          id: serverNumber.toString(),
          serverID: '0',
          name: "Channel $serverNumber",
        );
      });
      channelListLoaded = Future.value();
    } else {
      channelListLoaded = fetchChannels();
      // fetchChannels();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchChannels() async {
    log("Fetching channels for server ID ${widget.currentServerID}...");
    final response = await dioClient.dio.get(
      '/api/channel/fetch',
      queryParameters: {"serverID": widget.currentServerID},
    );
    final List<dynamic> rawList = jsonDecode(response.data);

    setState(() {
      channelList = rawList
          .map(
            (jsonMap) => ChannelModel.fromJson(jsonMap as Map<String, dynamic>),
          )
          .toList();
    });

    if (channelList.isNotEmpty && !state.mobile.value) {
      selectChannel(channelList.first.id);
    }
  }

  void selectChannel(String channelID) {
    final results = channelList.where((channel) => channel.id == channelID);
    if (results.isNotEmpty) {
      setState(() {
        currentChannelID = results.first.id;
      });
      log("Selected channel ID $channelID");

      if (state.mobile.value) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(channelID)),
              body: MessageArea(channelID: channelID),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          state.mobile.value
              ? Expanded(child: _channelList())
              : SizedBox(width: 240, child: _channelList()),
          !state.mobile.value
              ? Expanded(
                  // width: 300,
                  child: MessageArea(
                    key: ValueKey(currentChannelID),
                    channelID: currentChannelID,
                  ),
                )
              : SizedBox.shrink(),
          !state.mobile.value
              ? Container(
                  width: 240,
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  child: Column(children: [Top(childWidget: Text("members"))]),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _channelList() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      child: Column(
        children: [
          Top(childWidget: Text(widget.currentServerID)),
          Expanded(
            child: FutureBuilder(
              future: channelListLoaded,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return DelayedLoadingIndicator();
                }

                if (asyncSnapshot.hasError) {
                  return handleError(asyncSnapshot.error);
                }

                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: channelList.length,
                      itemBuilder: (context, index) {
                        final channel = channelList[index];
                        return Channel(
                          key: ValueKey(channel.name),
                          id: channel.id,
                          name: channel.name,
                          selected: channel.id == currentChannelID,
                          onClicked: selectChannel,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
