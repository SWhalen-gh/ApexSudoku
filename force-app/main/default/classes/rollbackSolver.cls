public class rollbackSolver {
    private static boolean isSolved;
    public static integer cpuCost=0;
    public static string endingPuzzle = '';

// Function to convert puzzle string to 2D integer array
    public static Integer[][] convertPuzzleString(String puzzle) {
      
      
        //System.debug(loggingLevel.warn,'starting puzzle = ' + puzzle);
        list<string> numbers = puzzle.split(''); 
        List<List<Integer>> board = new List<List<Integer>>();
        Integer index = 0;
        for(Integer i = 0; i < 9; i++) {
            List<Integer> row = new List<Integer>();
            for(Integer j = 0; j < 9; j++) {
                
               integer digit = Integer.valueOf(numbers[index]);
                row.add(Integer.valueOf(digit));
                index++;
            }
            board.add(row);
        }
         
        return board;
        
    }

    public static String solveSudoku(string board) {

         
        integer[][] boardArray = rollbackSolver.convertPuzzleString(board);

        boolean isSolved = rollbackSolver.solveSudoku(boardArray);
        
        string solvedPuzzle = '';

        for(Integer[] innerArray : boardArray) {
            // Join elements of inner array into a string
            String innerString = String.join(innerArray, '');
            // Concatenate inner strings with line breaks
            solvedPuzzle += innerString;
        }
        
        

        solvedPuzzle = '<solution>';
        for(Integer[] innerArray : boardArray) {
            // Start a new row element
            solvedPuzzle += '<row>';
            // Add data from inner array
            //String innerString = String.join(innerArray, '');
            for (integer ch : innerArray){
                solvedPuzzle += ('<cell>' + ch + '</cell>');
            }

           // solvedPuzzle += innerString;
            // Close the row element
            solvedPuzzle += '</row>';
        }
        // Close the solution element
        solvedPuzzle += '</solution>';





        return solvedPuzzle;
    }
 

    // Function to solve Sudoku
    public static boolean solveSudoku(Integer[][] board) {
        Integer row = -1;
        Integer col = -1;
        Boolean isEmpty = true;
        
        // Find unassigned location
        for (Integer i = 0; i < 9; i++) {
            for (Integer j = 0; j < 9; j++) {
                if (board[i][j] == 0) {
                    row = i;
                    col = j;
                    isEmpty = false;
                    break;
                }
            }
            if (!isEmpty) {
                break;
            }
        }
        
        // If no unassigned location, puzzle is solved
        if (isEmpty) {
            if (rollbackSolver.isSolved == false){
                rollbackSolver.isSolved = true;
                cpuCost=system.limits.getCPUTime();

                System.debug(loggingLevel.warn, 'TRUE! Board = ' + board);
        	    system.debug(loggingLevel.warn, 'CPU = ' + cpuCost);
            }
            return true;
        }
        
        // Try placing digits 1-9
        for (Integer num = 1; num <= 9; num++) {
            if (isSafe(board, row, col, num)) {
                board[row][col] = num;
                if (solveSudoku(board)) {
                
                    return true;
                } else {
                    board[row][col] = 0; // Backtrack
                }
            }
        }
        
        return false; // Trigger backtracking
    }
    
    // Function to check if a digit can be placed at a given location
    private static boolean isSafe(Integer[][] board, Integer row, Integer col, Integer num) {
        return !usedInRow(board, row, num) &&
               !usedInCol(board, col, num) &&
               !usedInBox(board, row - Math.mod(row, 3), col - Math.mod(col, 3), num);
    }
    
    // Function to check if a digit is already used in a row
    private static boolean usedInRow(Integer[][] board, Integer row, Integer num) {
        for (Integer col = 0; col < 9; col++) {
            if (board[row][col] == num) {
                return true;
            }
        }
        return false;
    }
    
    // Function to check if a digit is already used in a column
    private static boolean usedInCol(Integer[][] board, Integer col, Integer num) {
        for (Integer row = 0; row < 9; row++) {
            if (board[row][col] == num) {
                return true;
            }
        }
        return false;
    }
    
    // Function to check if a digit is already used in a 3x3 box
    private static boolean usedInBox(Integer[][] board, Integer boxStartRow, Integer boxStartCol, Integer num) {
        for (Integer row = 0; row < 3; row++) {
            for (Integer col = 0; col < 3; col++) {
                if (board[row + boxStartRow][col + boxStartCol] == num) {
                    return true;
                }
            }
        }
        return false;
    }
}