@isTest
public class SudokuTest {

//007000900450000003300520800000032080000908000090670000004086005200000074001000300
//https://www.sudokuwiki.org/sudoku.htm?bd=007000900450000003300520800000032080000908000090670000004086005200000074001000300
//https://www.sudokuwiki.org/sudoku.htm?bd=000003000078000605500700001000641030000020000900000080006400000000500240050006000
        
    //0802 puzzle is https://www.sudocue.net/pony.php?id=Z0WcGH5Op0WmNiK3qe1r3g
    private static string game1 = '080200000004000050000700004003000700000620500090001020002050009600000080500304000'; 
    private static string game2 = '300000000801700040000004200000000020020000017000590003700805060000000590006000000';
    private static string game3 = '500400000000000900090120070450090003000060080730000000007280040200000809600000050';
    private static string game4 = '000080000200060700600039000590000002000000687000000000020000000005600018007010406';
    private static string game5 = '009107340100004050600000000000030100002000090504600002006000000000400009000921000';
    private static string game528 = '048050903306000000000000007000000030001029800003840000709000400080000020000000005';
    
    //Locked Candidates (type 2)
    private static string game6 = '500200010001900730000000800050020008062039000000004300000000000080467900007300000';
    
    //Unlocked Single
    private static string game7 = '050007690000040000009000000000100004000230008008000150000400003006080209002005000';
    
    //8 is Locked Candidates (type 1)
    private static string game8 = '000023000004000100050084090001070902093006000000010760000000000800000004060000587';
    //naked pair:
    private static string game9 = '005100000600073000300000706000030601009750400802090000401000005000500008000007200';
    //naked triple:
    private static string game10 = '200000007015000020080200006000000064890000000000050910040815000061030000000006400';
  private static string game10b =  '230500047015000029080200006150000064890100000000050918040815600061030080008006401';
    //hidden pair
    private static string game11 = '800070009010000050700608003380105074000207000200030005008409500100000006090000040'; 
    //hidden triple
    private static string game12 = '605301204703000509000000000100936007000000000900457001000000000807000402309108706';
    private static string game122 ='605301204703004509200000000152936847476812005938457621500000000807000402309108756';
    private static string game0 = '400079600008000000360000700005040000000200070009000026800307000000000005030104000';
    
    private static string book1 = //page 70
        '702100005090300000080000470040026810000090000029810030061000040000005060200001708';
    private static string book184 = //page 184
        '000002907070000060008047030705000020490000073030000609040620700010000050802700000';

        private static string book221 = //page 249
            '050001600306000000009300204000030102000804000805020000601005300000000901007200040';
       
   private static string lockCandidate2 = '040080700020000000800030510000208906000009020000500000100000300090406005000050000';
/*
 * 
 *      000042059450090008000000000000004080000000703000836002369200001700000000005001600
        000000000360000920000010070000000204000036500100025730072809300900000080040000000
600400030000001050410800000040350200000700008002060500900000000730500086004000700
000300805060000030000050267006100002003405700004008000278000900000001000000000600
040080700020000000800030510000208906000009020000500000100000300090406005000050000 
  */  
    
    @isTest 
    static void testRollback() {
          //game12 is slow and 10
        string puzzle = game10;
        rollbackSolver.convertPuzzleString(puzzle) ;
    }
 
    @isTest
    static  void testLoadFromString() {
         //safe puzzles: game6, game7, game8, game9, game11
        GameData gd = new GameData();
      
        string result = gd.solve(game5);
        
        system.debug(loggingLevel.warn, 'test result = ' + result);
        
        gd.printGame(false);
        
    }
    
    @isTest
    static  void fastPuzzles1() {
          
        list<string> puzzles = new list<string> {
            game5, game6, game7,
            game8, game9, game11
        };
        
        for  (string puzzle :puzzles) { 
            GameData gd = new GameData();
            string result = gd.solve(puzzle);
            system.debug(loggingLevel.warn, 'test result = ' + result);
            system.assert.istrue(!result.contains('0'));
        }
   /*
        gd = new GameData();
        result = gd.solve(game2);
        system.debug(loggingLevel.warn, 'test result = ' + result);
        system.assert.istrue(!result.contains('0'));
        
        gd = new GameData();
        result = gd.solve(game3);
        system.debug(loggingLevel.warn, 'test result = ' + result);
        system.assert.istrue(!result.contains('0'));
        
        */
        
    }
    
    
    
    static   void testDML(){
        sudoku s = new sudoku();
        
        list<GameCell>  cells = s.getCells();
        integer i = cells.size();
        system.debug(loggingLevel.warn, 'i = ' + i);
        system.assertEquals(81, i); 
        
        string gameName ='testDML';
        s.save(gameName);
        s.load(gameName);
       
        gameData gd = s.getGameData();
        
        system.debug(loggingLEvel.warn, 'gamedata= '+ gd);
        
    }
    
    static   void testInitalization(){
        sudoku s = new sudoku();
        
        list<GameCell>  cells = s.getCells();
        integer i = cells.size();
        system.debug(loggingLevel.warn, 'i = ' + i);
        system.assertEquals(81, i);
        system.debug('showing cells');
        system.debug(loggingLEvel.warn, 'cells = ' + cells);  
         
        system.debug(loggingLevel.warn, 'GETTING cell 00');
         
        gameCell c = s.getCell(0,0);
        system.debug(loggingLEvel.warn, 'c = '+ c);
        
        integer b = c.box;
        system.assertEquals(0, b); 
       
        c = s.getCell(4,4);
        b = c.box;
        system.assertEquals(4, b); 
         
        c = s.getCell(7,7);
        b = c.box;
        system.assertEquals(8, b); 
          
    }
    
    static   void testRules() {
        
        sudoku s = new sudoku(); 
        gameData gd = s.getGameData();
           
        gameCell c11 = gd.getCell(1,1);
        c11.cellValue = 3;
        
        gameCell c40 = gd.getCell(4,0);
        c40.cellValue = 2;
          
        set<gameCell> b= gd.getBox(c11.box);
         
        system.debug(loggingLevel.warn, 'b= '+ b);
          
    }
    
}