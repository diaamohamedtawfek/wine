import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WitingShimmerList extends StatefulWidget {


  const WitingShimmerList({Key? key}) : super(key: key);

  @override
  _WitingShimmerListState createState() => _WitingShimmerListState();
}

class _WitingShimmerListState extends State<WitingShimmerList> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(22),
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Color(0xFF00838f),
        enabled: true,
        child: ListView.builder(
          itemCount: 16,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 68.0,
                  height: 68.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
