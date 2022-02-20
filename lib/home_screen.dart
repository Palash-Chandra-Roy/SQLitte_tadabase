import 'package:flutter/material.dart';
import 'package:sq_lite/database.dart';
import 'package:sq_lite/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<HomePage> {

  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  void initSate(){
    super.initState();
    dbHelper=DBHelper();
    loadData();
  }
  loadData()async{
    notesList =dbHelper!.getNotesList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notes SQL"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
           child:FutureBuilder(
            future: notesList,
              builder:(context, AsyncSnapshot<List<NotesModel>> snaphsot){
              return ListView.builder(
                itemCount: snaphsot.data?.length,
                  reverse: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  if(snaphsot.hasData) {
                    return InkWell(
                      onTap: (){
                        dbHelper!.update(
                          NotesModel(
                            id: snaphsot.data![index].id,
                              title: 'First flutter Notes',
                              age: 21,
                              description: 'this is Update flutter package',
                              email:'palashtpi21@gmail.com'
                          )
                        );
                        setState(() {
                          notesList=dbHelper!.getNotesList();
                        });
                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete_forever),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(snaphsot.data![index].id!);
                            notesList=dbHelper!.getNotesList();
                            snaphsot.data!.remove(snaphsot.data![index].id!);
                          });
                        },
                        key: ValueKey<int>(snaphsot.data![index].id!),
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(snaphsot.data![index].id.toString()),
                            subtitle: Text(snaphsot.data![index].description.toString()),
                            trailing: Text(snaphsot.data![index].age.toString()),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return CircularProgressIndicator();
                   }
                  });
              }
           ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
            NotesModel(
                title: 'first Notes',
                age: 21,
                description: 'this is my first sql app',
                email: 'palashtpi21@gmail.com')
          ).then((value){
            print('data added');
            setState(() {
             notesList=dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace){
            print(error.toString());
          });
        },
        child:const Icon(Icons.add),
      ),
    );
  }
}
