class MapParams
{
 int nbIterationsMin;
int nbIterationsMax;
int nbSubIterationsMin;
int nbSubIterationsMax;
int nbMinRooms;
int nbMaxRooms;
float ratioBigRooms;

  MapParams(int _nbIterationsMin,
int _nbIterationsMax,
int _nbSubIterationsMin,
int _nbSubIterationsMax,
int _nbMinRooms,
int _nbMaxRooms, float _ratioBigRooms)
{
   nbIterationsMin = _nbIterationsMin;
   iterationsMinSlider.setValue(nbIterationsMin);
   nbIterationsMax = _nbIterationsMax;
   iterationsMaxSlider.setValue(nbIterationsMax);
   
  nbSubIterationsMin = _nbSubIterationsMin;
   minCorridorsSlider.setValue(nbSubIterationsMin);
  nbSubIterationsMax = _nbSubIterationsMax;
   maxCorridorsSlider.setValue(nbSubIterationsMax);
  nbMinRooms = _nbMinRooms;
   MinRoomsSlider.setValue(nbMinRooms);
  nbMaxRooms = _nbMaxRooms;
   MaxRoomsSlider.setValue(nbMaxRooms);
   
   ratioBigRooms = _ratioBigRooms;
    ratioBigRoomsslider.setValue(ratioBigRooms);
}

}

class MapInfos
{
  
int nbCountRooms = 0;
int nbCountCorridors = 0;
int nbCountCroisements = 0;
int nbCountDoors = 0; 
int distanceMax = 0;
  MapInfos()
  {
     nbCountRooms = 0;
 nbCountCorridors = 0;
 nbCountCroisements = 0;
 nbCountDoors = 0; 
 distanceMax = 0;
  }
}


void PrintReport()
{
 meanInfos = new MapInfos();
 for(MapInfos m : stockInfos)
 {
   if(m!=null)
   {
     meanInfos.nbCountRooms += m.nbCountRooms;
     meanInfos.nbCountCorridors += m.nbCountCorridors;
     meanInfos.nbCountCroisements += m.nbCountCroisements;
     meanInfos.nbCountDoors += m.nbCountDoors;
     meanInfos.distanceMax += m.distanceMax;
   }
 }
}

 int nbIterationsMin;
int nbIterationsMax;
int nbSubIterationsMin;
int nbSubIterationsMax;
int nbMinRooms;
int nbMaxRooms;
float ratioBigRooms;


void saveJsonPreset()
{
  JSONObject json = new JSONObject();

  json.setInt("nbIterationsMin", mapParams.nbIterationsMin);
  json.setInt("nbIterationsMax", mapParams.nbIterationsMax);
  json.setInt("nbSubIterationsMin", mapParams.nbSubIterationsMin);
  json.setInt("nbSubIterationsMax", mapParams.nbSubIterationsMax);
  json.setInt("nbMinRooms", mapParams.nbMinRooms);
  json.setInt("nbMaxRooms", mapParams.nbMaxRooms);
  json.setFloat("ratioBigRooms", mapParams.ratioBigRooms);

  if(savePath == "preset") savePath = "preset"+ hex((int)random(0xffff), 4);
  saveJSONObject(json, "data/paramsPresets/"+savePath+".json"); 
  InitPresetsList();
}

void loadJsonPreset()
{
  JSONObject json = new JSONObject();
  json = loadJSONObject("paramsPresets/"+loadPath);
  
  mapParams = new MapParams(json.getInt("nbIterationsMin"),
json.getInt("nbIterationsMax"),
json.getInt("nbSubIterationsMin"),
json.getInt("nbSubIterationsMax"),
json.getInt("nbMinRooms"),
json.getInt("nbMaxRooms"), json.getFloat("ratioBigRooms"));

    wantToGenerate = true;
}

void InitPresetsList()
{
  java.io.File folder = new java.io.File(dataPath("paramsPresets"));
  String[] filenames = folder.list();// display the filenames
  for (int i = 0; i < filenames.length; i++) {
  println(filenames[i]);
}
   saveStrings("data/list_362683", filenames);
   LoadPreset.setItems(loadStrings("list_362683"), 0);
}  