library progress_timeline;

import 'package:flutter/material.dart';
import 'package:newtest/model/cricket_model.dart';
import 'package:newtest/screen/Cricket/timeline/provider/timeline_cricket_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

class ProgressTimeline extends StatefulWidget {
  final _ProgressTimelineState state = _ProgressTimelineState();
  @override
  _ProgressTimelineState createState() => state;
}

class _ProgressTimelineState extends State<ProgressTimeline> {
  List<SingleState> states;
  double height = 550;

  final _controller = ItemScrollController();
  TimeLineCircketProvider timeLineCricketProviderRead;

  @override
  void initState() {
    timeLineCricketProviderRead = context.read<TimeLineCircketProvider>();
    timeLineCricketProviderRead.setSingleStateList();
    states = [...timeLineCricketProviderRead.allStages];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeLineCircketProvider>(
      builder: (context, value, child) {
        return child;
      },
      child: Container(
        height: height,
        child: ScrollablePositionedList.builder(
          itemCount: buildStates().length,
          itemScrollController: _controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return buildStates()[index];
          },
        ),
      ),
    );
  }

  List<Widget> buildStates() {
    List<Widget> allStates = [];
    for (var i = 0; i < states.length; i++) {
      allStates.add(_RenderedState(
        stateNumber: i + 1,
        isCurrent: i == context.watch<TimeLineCircketProvider>().currentStep,
        isChecked: i < context.watch<TimeLineCircketProvider>().currentStep,
        stateTitle:
            context.watch<TimeLineCircketProvider>().allStages[i].stateTitle,
        dateTime:
            context.watch<TimeLineCircketProvider>().allStages[i].dateTime,
        isLeading: i == 0,
        isTrailing: i == states.length - 1,
      ));
    }
    return allStates;
  }
}

class _RenderedState extends StatelessWidget {
  final Icon checkedIcon;
  final Icon currentIcon;
  final Icon failedIcon;
  final Icon uncheckedIcon;
  final bool isChecked;
  final String stateTitle;
  final TextStyle textStyle;
  final bool isLeading;
  final bool isTrailing;
  final int stateNumber;
  final bool isFailed;
  final bool isCurrent;
  final double iconSize;
  final Color connectorColor;
  final double connectorLength;
  final double connectorWidth;
  final DateTime dateTime;

  _RenderedState(
      {@required this.isChecked,
      @required this.stateTitle,
      @required this.stateNumber,
      double iconSize,
      Color connectorColor,
      double connectorLength,
      double connectorWidth,
      TextStyle textStyle,
      this.failedIcon,
      this.currentIcon,
      this.checkedIcon,
      this.uncheckedIcon,
      this.isFailed = false,
      this.isCurrent,
      this.isLeading = false,
      this.isTrailing = false,
      this.dateTime})
      : this.iconSize = iconSize ?? 35,
        this.connectorColor = connectorColor ?? Colors.green,
        this.connectorLength = connectorLength ?? 3,
        this.connectorWidth = connectorWidth != null ? connectorWidth / 2 : 45,
        this.textStyle = textStyle ?? TextStyle();

  Widget line() {
    return Container(
      color: connectorColor,
      height: connectorWidth,
      width: connectorLength,
    );
  }

  Widget spacer() {
    return Container(
      width: 3.0,
    );
  }

  Widget getCheckedIcon() {
    return this.checkedIcon != null
        ? Icon(
            this.checkedIcon.icon,
            color: this.checkedIcon.color,
            size: iconSize,
          )
        : Icon(
            Icons.check_circle,
            color: Colors.green,
            size: iconSize,
          );
  }

  Widget getCheckedDate() {
    return this.checkedIcon != null
        ? Text(
            DateFormat('dd-MM-yyyy').format(DateTime.now()),
            textAlign: TextAlign.end,
          )
        : Text(
            DateFormat('dd-MM-yyyy KK:mm a').format(DateTime.now()),
            textAlign: TextAlign.end,
          );
  }

  Widget getCurrentIcon() {
    return this.currentIcon != null
        ? Icon(
            this.currentIcon.icon,
            color: this.currentIcon.color,
            size: iconSize,
          )
        : Icon(
            Icons.adjust,
            color: Colors.green,
            size: iconSize,
          );
  }

  Widget getUnCheckedIcon() {
    return this.uncheckedIcon != null
        ? Icon(
            this.uncheckedIcon.icon,
            color: this.uncheckedIcon.color,
            size: iconSize,
          )
        : Icon(
            Icons.radio_button_unchecked,
            color: Colors.green,
            size: iconSize,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(child: Column(children: [if (!isLeading) line()])),
        Container(
          child: Row(children: <Widget>[
            dateTime != null
                ? Container(
                    child: Text(
                      dateTime.toString(),
                      textAlign: TextAlign.end,
                    ),
                    width: 167,
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0))
                : SizedBox(
                    width: 167,
                  ),
            Container(
              alignment: Alignment.center,
              child: renderCurrentState(),
            ),
            Container(
                child: Text(
                  stateTitle,
                  style: textStyle,
                ),
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0))
          ]),
        ),
      ],
    );
  }

  Widget renderCurrentState() {
    if (isChecked != null && isChecked) {
      return getCheckedIcon();
    } else if (isCurrent != null && isCurrent) {
      return getCurrentIcon();
    }
    return getUnCheckedIcon();
  }
}

class SingleState {
  /// Title of a state
  String stateTitle;
  DateTime dateTime;

  SingleState({@required this.stateTitle, this.dateTime});
}
