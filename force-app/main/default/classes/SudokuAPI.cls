@RestResource(urlMapping='/sudokusolution/*')
global with sharing class SudokuAPI {
//https://logictest-dev-ed.my.salesforce.com/services/apexrest/sudokusolution
//https://logictest-dev-ed.my.site.com/services/apexrest/sudokusolution  
//https://logictest-dev-ed.my.site.com/services/apexrest/sudokusolution?puzzle=530070000600195000098000060800060003400803001700020006060000280000419005000080079
//https://logictest-dev-ed.my.site.com/services/apexrest/sudokusolution?logic=true&puzzle=000003000078000605500700001000641030000020000900000080006400000000500240050006000
//https://logictest-dev-ed.my.site.com/services/apexrest/sudokusolution?logic=true&puzzle=000003000078000605500700001000641030000020000900000080006400000000500240050006000
//https://www.sudokuwiki.org/sudoku.htm?bd=000003000078000605500700001000641030000020000900000080006400000000500240050006000

        @HttpGet
        global static void  getSudokuSolution() {
            // Code here to return the sudoku grid

            String puzzle= '';
            boolean logic= false;
            boolean guess= false;
            boolean hybrid = false;

            try { 
                puzzle = RestContext.request.params.get('puzzle');
                puzzle = EncodingUtil.urlDecode(puzzle, 'UTF-8').trim();

                system.debug(loggingLevel.warn, 'parms = ' + RestContext.request.params );

                logic = Boolean.valueOf(RestContext.request.params.get('logic') ?? 'false');
                guess = Boolean.valueOf(RestContext.request.params.get('guess') ?? 'false');
                hybrid = Boolean.valueOf(RestContext.request.params.get('hybrid') ?? 'false') ;
            }
            catch (exception e){
                system.debug(loggingLevel.warn, 'error with  URL params= ' + RestContext.request.requestURI);
            }
            


            if (!logic && !guess && !hybrid ) hybrid = true;

            GameData gd = new GameData();
            string solution = 'error';
            try { 

                if (guess) {
                    solution = rollbackSolver.solveSudoku(puzzle);
                }
                else{ //logic or hybrid
                    solution = gd.solve(puzzle);
                    Boolean containsZeros = solution.contains('0');
                    If (!containsZeros || !hybrid) {
                        solution = gd.printGameXML(); 
                    }
                    
                    if (containsZeros && hybrid) {
                        system.debug(loggingLevel.warn, 'partial solution= ' + solution);
                        solution = rollbackSolver.solveSudoku(solution);

                    }
                }

            }

            catch(Exception e) {
                system.debug(loggingLevel.warn, 'error with puzzle data= ' + puzzle);
                system.debug(loggingLevel.warn, 'error solution= ' + solution);
                system.debug(loggingLevel.warn, 'error = ' +  e.getMessage());
                e= null;
            }

           // return solution;

            Boolean returnXML = false ; //false; //true;
            if (returnXML) {
           RestContext.response.addHeader('Content-Type', 'application/xml');
           RestContext.response.responseBody = Blob.valueOf(solution);
            }
            else {
            
                String resultXhtml = convertXMLToXHTML(solution);            
                RestContext.response.addHeader('Content-Type', 'application/xhtml+xml');
                RestContext.response.responseBody = Blob.valueOf(resultXhtml);
            
            }
               
         
    }
    
    
        // Method to convert XML to XHTML
    private static String convertXmlToXhtml(String xinput) {
        // Convert XML to XHTML logic here 
                  
        String durationString = '<p>' + 'duration = ' + system.limits.getCPUTime() + '</p>';          
                  
        String xhtml = xinput.replace('<solution>',
         '<!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml"><head><title>Puzzle Solution</title><style>table { border-collapse: collapse; margin: 0 auto; } td, th { border: 1px solid black; padding: 8px; }</style></head><body><div style="text-align: center;"><table border="1">');
        
         
        xhtml = xhtml.replace('<table border', durationString + '<table border'); 
        
        xhtml = xhtml.replace('</solution>', '</table></div></body></html>');
 
     xhtml = xhtml.replace('<row>', '<tr>');
    xhtml = xhtml.replace('</row>', '</tr>');

    
    xhtml = xhtml.replace('<cell>', '<td>');
    xhtml = xhtml.replace('</cell>', '</td>');

    
 
        // System.debug(loggingLEvel.warn, 'HTML grid= ' + xhtml);
 
 
       Return xhtml;
    }
   
    
    /*
    
     
    
    */
    
    
    
    
    
    
}