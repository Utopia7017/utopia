import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

Future<String?> getImageUrl(File image,int index)async{
  Logger logger = Logger("Get image url");
  try{
    final Reference storageReference =
    FirebaseStorage.instance.ref().child('demo$index');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
  on FirebaseException catch(e){
   logger.shout(e.message);
  }
  return null;
}