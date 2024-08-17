public class House {

    public enum houseTypes {ROW, COLUMN, BOX} 
    
    public integer position { public get; private set; } 
    public houseTypes typeOfHouse { public get; private set; }  
    public set<gameCell> members = new set<gameCell>();

    public set<gameCell> getMembersMinus(gameCell excludeThisCell) {
        set<gameCell> returnCells = new set<gameCell>();

        returnCells.addAll(members);
        returnCells.remove(excludeThisCell);

        return returnCells;
    }
    
    public house (houseTypes houseType, integer position){
        this.typeOfHouse  = houseType;
        this.position = position;
        this.members = new set<gameCell>();
        
     
    }
    

    public house (houseTypes houseType, integer position, set<gameCell> cells ){
        this.typeOfHouse  = houseType;
        this.position = position;
        members.addAll(cells); 
        
        if (members.size() >9){
            throw new CalloutException  ('house :'+ position  + ' house type= ' + typeOfHouse   + ' members TOO BIG= ' + members.size()  );
 
        }
    }
    
    public house (set<gameCell> cells) {
        
        members.addAll(cells);  
        
        if (members.size() >9){ 
            throw new CalloutException  ('house :'+ position  + ' house type= ' + typeOfHouse  + ' members TOO BIG= ' + members.size()  );
        }
    }
    
    public void validateValueForCell (gameCell testCell, integer v) {
    
        for (gameCell sibling : this.members){
                if ( !(sibling.r == testCell.r && sibling.c == testCell.c) 
                    &&  sibling.cellValue == v) { 
                    
                    system.debug(loggingLevel.warn, 'ERROR!? '+ ' HOUSE sibling already has value = ' + v 
                            + 'house :'+ position  + ' in r= ' +  testCell.r + ' c = ' + testCell.c );     
                         
                    throw new CalloutException  ('house :'+ position 
                            + ' sibling already has value = ' + v 
                            + ' in r= ' +  testCell.r + ' c = ' + testCell.c    );
                    
                }else {
                    sibling.candidates.remove(v);
                }
            } 
         
    }
    

    public integer getUniqueCandidateInCell(gameCell cell) {
        integer returnUniqueCandidate = null;
        set<integer> cellCandidates = cell.candidates.clone();
        Set<gameCell> siblings = this.getMembersMinus(cell);
        
        set<integer> siblingCandidates = new set<integer>();
        for (gameCell sibling :siblings){
            siblingCandidates.addAll(sibling.candidates);

        }
        
        cellCandidates.RemoveAll(siblingCandidates);
        
        if (cellCandidates.size() ==1 ) {
            returnUniqueCandidate  = cellCandidates.iterator().next();
        }

        return returnUniqueCandidate;
    }    
    
    public set<integer> getUniqueCandidatesInCell(gameCell cell) {
     
        set<integer> uniqueCandidates = cell.candidates.clone();
        
        Set<gameCell> siblings = this.members.Clone();
        siblings.remove(cell);
        set<integer> siblingCandidates = new set<integer>();
        for (gameCell sibling :siblings){
            siblingCandidates.addAll(sibling.candidates);

        }
        
        uniqueCandidates.RemoveAll(siblingCandidates);

        return uniqueCandidates;
    }    
    
    public set<integer> getDistinctCandidates() {
        set<integer> returnDistinctCandidates = new set<integer>();
        
        for (gameCell cell :members){
            returnDistinctCandidates.addAll(cell.candidates);
        }

        return returnDistinctCandidates ;
    }
    
    public map<integer, set<gameCell>> getCellsByCandidate() {
        map<integer, set<gameCell>> returnCellsByCandidate = new map<integer, set<gameCell>> ();
         
        for (gameCell cell : members){
            if (cell.cellValue > 0) continue;//skip solved cells
            for (integer candidate :cell.candidates){ 
                if (!returnCellsByCandidate.containsKey(candidate)) 
                    returnCellsByCandidate.put(candidate, new set<gamecell>()) ;    
                
                returnCellsByCandidate.get(candidate).add(cell);
                 
            }
        }     

        return returnCellsByCandidate;
    }
    
        
    public map<set<integer>, set<gameCell>> getCandidatesToCells() {
        map<set<integer>, set<gameCell>> returnCandidatesToCells = new map<set<integer>, set<gameCell>> ();
         
        list<gameCell> cellsBySize = new list<gameCell>(this.members);
        cellsBySize.sort(new GameCell.SizeCompare());
        
        
        for (gameCell cell : cellsBySize){
            if (cell.cellValue >0) continue; //skip cells that are already solved
             
            set<integer> mapKey = null;
            //this finds perfect matches and subsets
            for (set<integer> key : returnCandidatesToCells.keyset()){
                if (key.containsAll(cell.candidates)) {     
                    mapKey = key;
                    break;
                }   
            }
            if (mapKey != null) {//found one, so use .get()
                returnCandidatesToCells.get(mapKey).add(cell); 
            }            
            else{//otherwise, totally new, so use .put() : 
                returnCandidatesToCells.put(cell.candidates, (new set<gameCell>{cell}));
            }  
             
        }     

        return returnCandidatesToCells;
    }
     
    
    public map<integer, set<gameCell>> getCellsByCandidateBySize(integer filterSize){
        
        map<integer, set<gameCell>> returnCellsByCandidateBySize = new map<integer, set<gameCell>>();
     
        map<integer, set<gameCell>> cellsByCandidate = getCellsByCandidate();   
        for (integer candidate  : cellsByCandidate.KeySet()){
            if (cellsByCandidate.get(candidate).size() == filterSize)
                returnCellsByCandidateBySize.put(candidate, cellsByCandidate.get(candidate));
        }
        
        return returnCellsByCandidateBySize;
        
    }

    //get alternateAxisValues by Cell, frequency
    public map<integer, set<integer>> getAlternateAxisByCandidateByFrequency(integer filterSize){
        
        map<integer, set<integer>> returnAlternateAxisByCandidateBySize = new map<integer, set<integer>>();
     
        map<integer, set<gameCell>> cellsByCandidate = getCellsByCandidate();   
        for (integer candidate  : cellsByCandidate.KeySet()){
            if (cellsByCandidate.get(candidate).size() == filterSize){ 
                set<integer> alternateAxis = new set<integer>();
                for (gameCell gc : cellsByCandidate.get(candidate)) {
                    integer axisValue=  this.typeOfHouse == houseTypes.ROW? gc.c : gc.r;
                    alternateAxis.add(gc.r);
                }
                returnAlternateAxisByCandidateBySize.put(candidate, alternateAxis );
            }
        }
        
        return returnAlternateAxisByCandidateBySize ;
        
    }


      
    public set<gameCell> removeKnownValueFromCandidates(gameCell knownCell) {
        set<gameCell> changedCells = new set<gameCell>();  
                        
        integer v = knownCell.cellValue;     
        if (v ==0) { 
            return changedCells;
        }
         
        for (gameCell c : this.members) {
            if (c.r == knownCell.r && c.c == knownCell.c) { 
                continue;
            }

            boolean removed = c.removeCandidates(v);    
            if (removed) {
                changedCells.add(c);
            }
        }
         
        return changedCells; 
    }


    
}