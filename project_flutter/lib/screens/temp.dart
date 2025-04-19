import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter/models/document_model.dart';

import 'ReaderScreen.dart';

class temp extends StatefulWidget {
  const temp({super.key});

  @override
  State<temp> createState() => _tempState();
}

class _tempState extends State<temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
        title: Text("temp"),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0 ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hihi",
                  style: GoogleFonts.roboto(fontSize: 48.0, fontWeight: FontWeight.bold),
                ),

                Column(
                  children: Document.doc_list.map((doc)=>ListTile(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>ReaderScreen(doc)));
                    },
                    title: Text(
                      doc.doc_title!,
                      style: GoogleFonts.nunito(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text("${doc.page_num!} Pages"),
                    trailing: Text(
                      doc.doc_date!,
                      style: GoogleFonts.nunito(color: Colors.grey),
                    ),
                    leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 32.0,)
                  )).toList(),
                )
              ],
            ),
          )
      )
    );
  }
}
