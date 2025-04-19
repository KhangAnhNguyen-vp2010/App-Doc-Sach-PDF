import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter/models/document_model.dart';
import 'package:project_flutter/screens/Navigation.dart';
import 'package:project_flutter/screens/ReaderScreen.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeSceen();
  }
  
}

class _HomeSceen extends State<HomeScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
        title: Text("PDF Reader"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Documents",
              style: GoogleFonts.roboto(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Column(
              children: Document.doc_list.map((doc)=>ListTile(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ReaderScreen(doc)));
                },
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 32.0,),
                title: Text(
                    doc.doc_title!,
                    style: GoogleFonts.nunito(),
                    overflow: TextOverflow.ellipsis),
                subtitle: Text("${doc.page_num!} Page"),
                trailing: Text(
                    doc.doc_date!,
                    style: GoogleFonts.nunito(color: Colors.grey)),
              )).toList(),
            )
          ],
        ),
      )),

    );
  }
  
}


