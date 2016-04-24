---
date: 2009-11-17
comments: true
description: Using linq to solve Sudoku
categories:
  - C#
  - LinQ
  - programming
tags:
  - programming
  - linq
  - sudoku
summary: Using linq to solve Sudoku
title: Solve Sudoku in 1 line of Linq
url: /solve_sudoku_in_1_line_of_linq
---

One of my coworkers sent around a link today to someone who solved [Sudoku puzzles in 1 line of SQL](1) using Oracle's custom recursive syntax. I thought it would be fun to try to convert this into Linq. This is the "best" I was able to come up with. Just like all 1 line solution to complex problems the result looks horrific, although I'm happy to see that it solves the Sudoku puzzles quite quickly.

The solution I used is the [standard brute force algorithm](2) that many people use to solve the puzzles manually. The solution checks all numbers 1 - 9 in turn on each empty spot looking for the number in the column, row, and group of 3. This is accomplished by creating a tree structure of all possible "moves". The board starts as the root node and each branch is made up of filling in 1 empty spot with all possible numbers that fit the puzzle rules. Each level of the tree tries to solve another empty slot. This also means that the leaf node with the greatest depth is the solution to the puzzle.


{{< highlight csharp >}}
public static string SolveStrings(string Board)
{
    string[] leafNodesOfMoves = new string[] { Board };
    while ((leafNodesOfMoves.Length > 0) && (leafNodesOfMoves[0].IndexOf(' ') != -1))
    {
        leafNodesOfMoves = (
            from partialSolution in leafNodesOfMoves
            let index = partialSolution.IndexOf(' ')
            let column = index % 9
            let groupOf3 = index - (index % 27) + column - (index % 3)
            from searchLetter in "123456789"
            let InvalidPositions =
            from spaceToCheck in Enumerable.Range(0, 9)
            let IsInRow = partialSolution[index - column + spaceToCheck] == searchLetter
            let IsInColumn = partialSolution[column + (spaceToCheck * 9)] == searchLetter
            let IsInGroupBoxOf3x3 = partialSolution[groupOf3 + (spaceToCheck % 3) +
            (int)Math.Floor(spaceToCheck / 3f) * 9] == searchLetter
            where IsInRow || IsInColumn || IsInGroupBoxOf3x3
            select spaceToCheck
            where InvalidPositions.Count() == 0
            select partialSolution.Substring(0, index) + searchLetter + partialSolution.Substring(index + 1)
        ).ToArray();
    }
    return (leafNodesOfMoves.Length == 0)
        ? "No solution"
        : leafNodesOfMoves[0];
}
{{< /highlight >}}

[1]: http://technology.amis.nl/blog/6404/oracle-rdbms-11gr2-solving-a-sudoku-using-recursive-subquery-factoring "Sudoku solved in 1 line of SQL"
[2]: http://en.wikipedia.org/wiki/Algorithmics_of_sudoku
