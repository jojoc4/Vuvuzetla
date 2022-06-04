import 'package:application/models/Tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsRepository {
  late Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> _tagsName = [
    "Animals",
    "Food",
    "Fun",
    "Gaming",
    "Meme",
    "News",
    "NSFW",
    "Politics",
    "WTF"
  ];

  List<Tag> getTags(){
    List<Tag> tags = [];
    _prefs.then((SharedPreferences prefs) {
      for(var t in _tagsName){
        tags.add(Tag(name: t, active: prefs.getBool(t+"_active") ?? true));
      }
    });
    return tags;
  }
}