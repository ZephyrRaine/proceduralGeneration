class Room
{
  int tX;
  int tY;
  
  int tSizeX;
  int tSizeY;
  
  Room[] doors;
  
  boolean terminate;
  
  Room(int _x, int _y)
  {
    tX = _x;
    tY = _y;
    
    tSizeX = tSizeY = 1;
    
    doors = new Room[4];
    for(int i = 0; i < 4; i++) doors[i] = null;
  }
  
  void addDoor(int dir, Room target)
  {
   // doors[dir] = target; 
    nbCountDoors++;
  }
  
  void drawRoom()
  {
    int x = tX*tWidth;
    int y = tY*tHeight;
    
      fill(125,96,96,32);
      ellipse(x+tWidth/2.0, y+tHeight/2.0, tWidth, tHeight);
    if(tX == mouseX/tWidth && tY == mouseY/tHeight) 
    {
      fill(156,156,196,64);
    }
    else fill(156,156,196,196);
      rect(tSizeX<0?x+(tWidth*(tSizeX+1)):x, tSizeY<0?y+(tHeight*(tSizeY+1)):y, abs(tSizeX)*tWidth, abs(tSizeY)*tHeight);
  /*  
    for(int k = 0; k < 4; k++)
    {
     if(doors[k] != null)
       {
         switch(k)
         {
         case NORTH:
           line(x+tWidth/2, y, x+tWidth/2, y+tHeight/4);
           break;
         case SOUTH:
           line(x+tWidth/2, y+tHeight, x+tWidth/2, y+tHeight*0.75);
           break;
         case EAST:
           line(x+tWidth, y+tHeight/2, x+tWidth-tWidth/4, y+tHeight/2);
           break;
         case WEST:
           line(x, y+tHeight/2, x+tWidth/4, y+tHeight/2);
           break;
         }
       }
     }
  */
  }
  
}

void DrawRooms()
{
  pushMatrix();
  stroke(196);
  for(Room r : roomsList)
  {
    r.drawRoom();
  }

  popMatrix();
}

Boolean isValidFrom(int x, int y, int dir)
{
  switch(dir)
  {
   case NORTH:
    if(y+1 < tRows && gridArray[x][y+1] == null
    && x-1 > 0 && gridArray[x-1][y] == null
    && x+1 < tColumns && gridArray[x+1][y] == null) return true;
    else return false;
    case SOUTH:
    if(y-1 > 0 && gridArray[x][y-1] == null
    && x-1 > 0 && gridArray[x-1][y] == null
    && x+1 < tColumns && gridArray[x+1][y] == null) return true;
    else return false;
    case EAST:
    if(x-1 > 0 && gridArray[x-1][y] == null
    && y-1 > 0 && gridArray[x][y-1] == null
    && y+1 < tRows && gridArray[x][y+1] == null) return true;
    else return false;
    case WEST:
    if(x+1 < tColumns && gridArray[x+1][y] == null
    && y-1 > 0 && gridArray[x][y-1] == null
    && y+1 < tRows && gridArray[x][y+1] == null) return true;
    else return false;
  }
  
  return false;
}

void InitRooms()
{
                                    
  surface.setResizable(true);
  surface.setSize(mapWidth,mapHeight);
  
  tWidth = tempTWidth;
  tHeight = tempTHeight;
  
  mapWidth = tempMapWidth;
  mapHeight = tempMapHeight;
  
  tColumns = mapWidth/tWidth;
  tRows = mapHeight/tHeight;
  
  gridArray = new Room[tColumns][tRows];
  roomsList = new ArrayList<Room>();
  
  
 nbCountCorridors = 0;
 nbCountCroisements = 0;
 nbCountDoors = 0;

  
  for(int i = 0; i < tRows; i++)
  {
    for(int j = 0; j < tColumns; j++)
    {
      gridArray[j][i] = null;
    }
  }
  startingRoom = gridArray[tColumns/2][tRows/2] = new Room(tColumns/2, tRows/2);
  roomsList.add(startingRoom);
  
  createMaze(startingRoom, int(random(nbIterationsMin, nbIterationsMax+1)));
}