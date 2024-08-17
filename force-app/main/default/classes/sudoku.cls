public class sudoku {
    
    public id recordId;
     
    private gameData gd;
    
    public gameData getGameData() {
        return gd;
    }
    
    //integer size = 8; //0 through 8 is nine elements
    //private static set<integer> values = new set<integer> {1,2,3,4,5,6,7,8,9};  
      
    public list<GameCell> getCells() {
        return gd.getCells().values(); 
    }
    
    public gameCell getCell(integer x,integer y) {
        return this.gd.getCell(x,y);
        
    }
      
    public sudoku() {
    	this.gd = new gameData();
        this.gd.initalizeCells();
         
    }
    
    public void save(string gameName) {
        gd.save(gameName);
        
    }
    
    public void load(string gameName) {
        gd.load(gameName);
        
    }
     
}