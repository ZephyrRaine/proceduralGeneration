class MapParams
{
 int nbIterationsMin;
int nbIterationsMax;
int nbSubIterationsMin;
int nbSubIterationsMax;
int nbMinRooms;
int nbMaxRooms;

  MapParams(int _nbIterationsMin,
int _nbIterationsMax,
int _nbSubIterationsMin,
int _nbSubIterationsMax,
int _nbMinRooms,
int _nbMaxRooms)
{
   nbIterationsMin = _nbIterationsMin;
   nbIterationsMax = _nbIterationsMax;
  nbSubIterationsMin = _nbSubIterationsMin;
  nbSubIterationsMax = _nbSubIterationsMax;
  nbMinRooms = _nbMinRooms;
  nbMaxRooms = _nbMaxRooms;
  
}

}

class MapInfos
{
  
int nbCountRooms = 0;
int nbCountCorridors = 0;
int nbCountCroisements = 0;
int nbCountDoors = 0; 
  MapInfos()
  {
     nbCountRooms = 0;
 nbCountCorridors = 0;
 nbCountCroisements = 0;
 nbCountDoors = 0; 
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
   }
 }
   meanInfos.nbCountRooms /= stockInfos.size();
     meanInfos.nbCountCorridors /= stockInfos.size();
     meanInfos.nbCountCroisements /= stockInfos.size();
     meanInfos.nbCountDoors /= stockInfos.size();
}