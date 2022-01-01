import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/design/Dimensions.dart';
import 'package:project/design/TextStyles.dart';
import 'package:project/models/ItemPage.dart';
import 'package:project/services/itemsService.dart';
import 'package:project/routes/mapView.dart';


class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  itemsService _itemsService = itemsService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: _itemsService.getStatus(),
      builder: (context,snaphot){
        return !snaphot.hasData ? CircularProgressIndicator() : ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: snaphot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            DocumentSnapshot post = snaphot.data!.docs[index];

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemPage(iid: post.id)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal:5,
                  ),
                  padding: EdgeInsets.symmetric(horizontal:10,vertical:15),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent[400],

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(post["image"]),
                            radius: size.height* 0.08,
                          ),
                          Flexible(
                            child: Text(
                              "${post["name"]}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ],

                      ),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${post["price"]}",
                              style: TextStyle(
                                fontSize: 16,

                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40,0,0,0),
                              child: IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MapApp(
                                          camPosition: LatLng(40.889550,29.374065),
                                          title: "${post["name"]}",
                                          price: "${post["price"]}",
                                      )),
                                      //TODO have to add LatLng values to each item
                                    );
                                  },
                                  icon: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40,0,0,0),
                              child: OutlinedButton(
                                  onPressed: (){},
                                  child: Text("Add2Cart"),
                                  style: mainBstyle
                              ),
                            ),
                          ],
                        ),
                      ),




                    ],
                  ),

                ),
              ),
            );
          },
        );
      },

    );
  }
}
