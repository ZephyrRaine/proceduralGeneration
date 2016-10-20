import g4p_controls.*;

final int NORTH = 0;
final int SOUTH = 1;
final int WEST = 2;
final int EAST = 3;

final int NW = 0;
final int NE = 1;
final int SW = 2;
final int SE = 3;  

int tHeight = 32;
int tWidth = 32;

int tempTWidth = 32;
int tempTHeight = 32;

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
boolean showOrigin = true;
boolean showDistance = true;

String savePath = "preset";
String loadPath = "";

boolean wantToGenerate = false;


void setup()
{
  
  size(1080,1080);
  createGUI();
  InitPresetsList();
  meanInfos = new MapInfos();
  stockInfos = new ArrayList<MapInfos>();
  mapParams = new MapParams(2,2,1,2,1,2,0.15);
  InitRooms();
}

void distanceFromStart()
{
  ArrayList<Room> queue = new ArrayList<Room>();
  ArrayList<Room> visited = new ArrayList<Room>();
  queue.add(startingRoom);
  visited.add(startingRoom);
  startingRoom.distanceFromStart = 0;
  Room current;
  
  while(queue.size() != 0)
  {
    current = queue.remove(0);
    for(int i = 0; i < 4; i++)
    {
      for(int j = 0; j < 2; j++)
      {
        Room d = current.doors[i][j];
        if(d != null && !visited.contains(d))
        {
           queue.add(d);
           visited.add(d);
           d.distanceFromStart = current.distanceFromStart + 1;
           if(d.distanceFromStart > mapInfos.distanceMax) mapInfos.distanceMax = d.distanceFromStart;
        }
      }
    }
  }
  
  boolean isGood = true;
  
  for(Room r : roomsList)
  {
    if(r != startingRoom && r.distanceFromStart == 0)
    {
      isGood = false;
    }
  }
    
  if(!isGood) InitRooms();
}

void draw()
{  
  background(64);
  if(showGrid) DrawGrid();
  if(wantToGenerate) InitRooms();
  DrawRooms();
  mapInfos.nbCountRooms = roomsList.size();
  if(showInfos) DrawInfos();
}

void DrawInfos()
{
  int x = int(mapWidth*0.70);
  int y = int(mapHeight*0.05);
  pushMatrix();
  strokeWeight(2);
  stroke(196,196);
  fill(16,96);
  rect(x,y,250,200);
  textSize(12);
  fill(255);
  
  text("Nombre Rooms : " + mapInfos.nbCountRooms + " ("+meanInfos.nbCountRooms/float(stockInfos.size())+")", x + 15, y + 15);
  text("Distance Max : " + mapInfos.distanceMax+ " ("+meanInfos.distanceMax/float(stockInfos.size())+")", x + 15, y + 30);
  popMatrix();
}


void DrawGrid()
{
  pushMatrix();
  stroke(96);
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
        
        break;
        case SOUTH:
        source = gridArray[from.tX][from.tY+(offset-1)];
        target = gridArray[from.tX][from.tY+offset] = new Room(from.tX, from.tY+offset);
        
        break;
        case EAST:
        source = gridArray[from.tX+(offset-1)][from.tY];
        target = gridArray[from.tX+offset][from.tY] = new Room(from.tX+offset, from.tY);
        
        
        break;
        case WEST:
        source = gridArray[from.tX-(offset-1)][from.tY];
        target = gridArray[from.tX-offset][from.tY] = new Room(from.tX-offset, from.tY);
        
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
    if(r != null) 
    {
      println(r.distanceFromStart);
    }
}

void keyPressed()
{
  if(key == 'h')showGrid = !showGrid;
  if(key == 'i')showInfos = !showInfos;
  if(key == 'o')showOrigin = !showOrigin;
  if(key == 'd')showDistance = !showDistance;
  if(key == 'g') InitRooms();
  if(key == 'e') ExpandRooms();
}