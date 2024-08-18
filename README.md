This is a project written in Salesforce Apex that solves sudoku puzzles.  

The test classes follow the solving guide here, starting at "naked singles" and through "x-wing".
https://www.sudocue.net/guide.php

If the solver can't solve a puzze with logic, it will send the remaining cells to a brute force solver. I take no credit for the brute force solver; it was offered by ChatGPT. It is canonical backtracking algorithm as detailed here:
https://en.wikipedia.org/wiki/Sudoku_solving_algorithms

The Apex has a public REST/GET endpoint that accepts puzzles in this format:
https://logictest-dev-ed.my.site.com/services/apexrest/sudokusolution?puzzle=001605002007900008060003000080007021000000000003060470008020000504009200300004500

Sample puzzles in that string format can be found here:
https://www.sudocue.net/lite.php
the string is under the puzzle, under the buttons

and here:
https://www.sudokuwiki.org/sudoku.htm
to get the string, click "load in solver" and then click "Email this board"



