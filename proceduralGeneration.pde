import g4p_controls.*;

final int NORTH = 0;
final int SOUTH = 1;
final int WEST = 2;
final int EAST = 3;

final int NW = 0;
final int NE = 1;
final int SW = 2;
final int SE = 3;  

int tHeight = 16;
int tWidth = 16;

int tempTWidth = 16;
int tempTHeight = 16;

int mapWidth = 960;
int mapHeight = 960;

int tempMapWidth = 960;
int tempMapHeight = 960;

int tColumns;
int tRows;

MapParams mapParams;
MapInfos mapInfos;

Room[][] gridArray;
ArrayList<Room> roomsList;

ArrayList<MapInfos> stockInfos;
MapInfos meanInfos;

Room startingRoom;

boolean showGrid = true;
boolean showInfos = true;

float ratioBigRooms = 0.10f; //.0f;

void setup()
{
  size(1080,1080);
  meanInfos = new MapInfos();
  stockInfos = new ArrayList<MapInfos>();
  mapParams = new MapParams(2,2,1,2,1,2);
  InitRooms();
  createGUI();
}

void draw()
{  
  background(96);
  if(showGrid) DrawGrid();
  DrawRooms();
  mapInfos.nbCountRooms = roomsList.size();
  if(showInfos) DrawInfos();
}

void DrawInfos()
{
  int x = int(mapWidth*0.75);
  int y = int(mapHeight*0.05);
  pushMatrix();
  strokeWeight(2);
  stroke(196,196);
  fill(16,96);
  rect(x,y,200,200);
  textSize(12);
  fill(255);
  
  text("Nombre Rooms : " + mapInfos.nbCountRooms + "("+meanInfos.nbCountRooms+")", x + 15, y + 15);
  text("Nombre Couloirs : " + mapInfos.nbCountCorridors+ "("+meanInfos.nbCountCorridors+")", x + 15, y + 30);
  text("Nombre Croisements : " + mapInfos.nbCountCroisements+ "("+meanInfos.nbCountCroisements+")", x + 15, y + 45);
  text("Nombre Portes : " + mapInfos.nbCountDoors+ "("+meanInfos.nbCountDoors+")", x + 15, y + 60);
  popMatrix();
}


void DrawGrid()
{
  pushMatrix();
  stroke(128);
  noFill();
  for(int i = 1; i <= tColumns; i++)line(i*tWidth,0,i*tWidth,tColumns*tWidth);
  for(int j = 1; j <= tRows; j++) line(0,j*tHeight,tRows*tHeight, j*tHeight);
  popMatrix();
}

void createMaze(Room _startingRoom, int _nbIterations)
{
  surface.setTitle("proceduralGeneration (Working...)");
  ArrayList<ArrayList<Room>> endpoints = new ArrayList<ArrayList<Room>>();
  for(int j = 0; j < _nbIterations; j++)
  {
    endpoints.add(new ArrayList<Room>());
    endpoints.get(j).add(_startingRoom);
    endpoints.add(new ArrayList<Room>());
mapInfos.nbCountCroisements++;
    for(Room room : endpoints.get(j))
    {
      for(int i = 0; i < 4; i++)
      {
         endpoints.get(j+1).add(createBranch(room,int(random(mapParams.nbSubIterationsMin,mapParams.nbSubIterationsMax+1)))); 
      }
    }
  }
  surface.setTitle("proceduralGeneration");
}

Room createBranch(Room _startingRoom, int _nbIterations)
{
  for(int j = 0; j < _nbIterations; j++)
  {
    IntList order = new IntList();
    for(int i = 0; i < 4; i++)
    { 
      order.append(i);
    }
    order.shuffle();
    
    Boolean canExpand = false;
    int index = 0;
    int nbCases = int(random(mapParams.nbMinRooms,mapParams.nbMaxRooms+1));
    do
    {
      canExpand = canExtrude(_startingRoom, order.get(index), nbCases);
      if(!canExpand) index++;
    } while(!canExpand && index < 3);
    
    if(canExpand)
    {
     _startingRoom = extrude(_startingRoom, order.get(index), nbCases); 
     mapInfos.nbCountCorridors++;
    }
  }
  
  return _startingRoom;
}

Boolean canExtrude(Room from, int dir, int nbCases)
{
  Boolean canExtrude = true;
  
  for(int offset = 1; offset <= nbCases+1; offset++)
  {
    switch(dir)
    {
      case NORTH:
      if(from.tY-offset < 0 || gridArray[from.tX][from.tY-offset] != null || !isValidFrom(from.tX,from.tY-offset, SOUTH)) canExtrude = false;
      break;
      case SOUTH:
      if(from.tY+offset > tRows-1 || gridArray[from.tX][from.tY+offset] != null || !isValidFrom(from.tX,from.tY+offset, NORTH)) canExtrude = false;
      break;
      case EAST:
      if(from.tX+offset > tColumns-1 || gridArray[from.tX+offset][from.tY] != null || !isValidFrom(from.tX+offset,from.tY, WEST)) canExtrude = false;
      break;
      case WEST:
      if(from.tX-offset < 0 || gridArray[from.tX-offset][from.tY] != null || !isValidFrom(from.tX-offset,from.tY, EAST)) canExtrude = false;
      break;
    }
  }
  
  return canExtrude;
}

Room extrude(Room from, int dir, int nbCases)
{
  Room lastRoom = null;
 // print("x: ", from.tX, "y: ", from.tY, "dir: ", dir, "nbCases: ", nbCases, "\n");
  
    
   Room source, target = null;
   for(int offset = 1; offset <= nbCases; offset++)
    {
      switch(dir)
      {
        case NORTH:
        source = gridArray[from.tX][from.tY-(offset-1)];
        target = gridArray[from.tX][from.tY-offset] = new Room(from.tX, from.tY-offset);
        
        source.addDoor(NORTH, target);
        target.addDoor(SOUTH, target); 
        break;
        case SOUTH:
        source = gridArray[from.tX][from.tY+(offset-1)];
        target = gridArray[from.tX][from.tY+offset] = new Room(from.tX, from.tY+offset);
        
        source.addDoor(SOUTH, target);
        target.addDoor(NORTH, target); 
        break;
        case EAST:
        source = gridArray[from.tX+(offset-1)][from.tY];
        target = gridArray[from.tX+offset][from.tY] = new Room(from.tX+offset, from.tY);
        
        source.addDoor(EAST, target);
        target.addDoor(WEST, target); 
        
        break;
        case WEST:
        source = gridArray[from.tX-(offset-1)][from.tY];
        target = gridArray[from.tX-offset][from.tY] = new Room(from.tX-offset, from.tY);
        
        source.addDoor(WEST, target);
        target.addDoor(EAST, target); 
        break;
      }
      roomsList.add(target);
    }
    lastRoom = target;
  
  return lastRoom;
}

void mouseClicked()
{
  Room r = gridArray[mouseX/tWidth][mouseY/tHeight];
  if(r != null && r.tSizeX == 1 && r.tSizeY == 1) ExpandRoom(r);
}

void keyPressed()
{
  if(key == 'h')showGrid = !showGrid;
  if(key == 'i')showInfos = !showInfos;
  if(key == 'g') InitRooms();
  if(key == 'e') ExpandRooms();
  if(key == 'p') PrintReport();
}