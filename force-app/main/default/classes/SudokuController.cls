public with sharing class SudokuController {
    // Public variables for gameData instance and Rows property
    
    public static gameData gameDataInstance { get; private set; }

    // Public getter method to expose the rows data
    @AuraEnabled(cacheable=true)
    public static  List<list<gameCell>>  fetchGameCells() {
 
        List<List<gameCell>> rowsList = new List<List<gameCell>>();
        
        // Iterate over the keys of the map and add the corresponding sets to the list
        map<integer, set<gameCell>> therows = gameDataInstance.getRows();
        for (Integer key : therows.keySet()) {
            List<gameCell> sortedCells = new List<gameCell>(theRows.get(key));
            //sortedCells.sort(); // Sort the list of game cells
            rowsList.add(sortedCells);

        }
        
        return rowsList;  //
 
    }

    // Private setter method to set the gameDataInstance
    private static void setGameData() {
        GameData gameDataInstance = new GameData();  
        // Perform any initialization or data retrieval here
    }
}