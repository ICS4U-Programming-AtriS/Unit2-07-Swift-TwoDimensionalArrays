//
//  ClassMarks.swift
//
//  Created by Atri Sarker
//  Created on 2025-10-26
//  Version 1.0
//  Copyright (c) 2025 Atri Sarker. All rights reserved.
//
//  Program that generates a mark table,
//  given a list of students and a list of assignments.

import Foundation

// Constant for Max Mark.
let maxMark = 100
// Constant for Min Mark.
let minMark = 0
// Constant for Median Mark.
let medianMark = 75.0
// Constant for Standard Deviation in the marks.
let stdDevMark = 10.0

// Helper function to generate a random mark
// Using Gaussian distribution
// Using Formulas from the internet
func generateRandomMark() -> Int {
    // Using Box-Muller transform to generate a normally distributed value
    let uniformNum1 = Double.random(in: 0..<1)
    let uniformNum2 = Double.random(in: 0..<1)
    // Generate the Gaussian value
    // I don't know how it works, I didn't make the formula
    let nextGaussian = sqrt(-2.0 * log(uniformNum1)) *
     cos(2.0 * Double.pi * uniformNum2)
    // Create the mark using the Gaussian value
    var mark: Int = Int(nextGaussian * stdDevMark + medianMark)

    // Clamp the mark
    if mark < minMark {
        mark = minMark
    } else if mark > maxMark {
        mark = maxMark
    }
    
    // Return the mark
    return mark
}

// Function that generates a 2D array of students and
// their marks for each assignment.
// It will come with a header row for assignments and
// a header column for student names.
func generateMarks(_ studentsArr: [String], _ assignmentsArr: [String]) -> [[String]] {
    // Create a 2D array
    var table: [[String]] = [[]]
    
    // Create the header row
    var headerRow: [String] = ["Students"] + assignmentsArr
    // Set the header row in the marks table
    table[0] = headerRow

    // Loop through row numbers
    for rowNum in 1...studentsArr.count {
        // Create variable for row
        var row: [String] = []
        // First column is the student name
        row.append(studentsArr[rowNum - 1])
        // Loop through column numbers
        for colNum in 1...assignmentsArr.count {
            // Generate a random mark
            let mark: Int = generateRandomMark()
            // Append the mark to the row
            row.append(String(mark))
        }
        // Append the row to the marks table
        table.append(row)
    }
    // Return the table
    return table
}

// Get all arguments
let arguments = CommandLine.arguments
// First argument is the path to the students file.
let studentsFilePath = arguments[arguments.startIndex + 1]
// Second argument is the path to the assignments file.
let assignmentsFilePath = arguments[arguments.startIndex + 2]
// Third argument is the path to the output file.
let outputFilePath = arguments[arguments.startIndex + 3]
// Print arguments
print("Students file: " + studentsFilePath)
print("Assignments file: " + assignmentsFilePath)
print("Output file: " + outputFilePath)
// Read data from both of the files and save them into arrays
guard let studentsFile = FileHandle(forReadingAtPath: studentsFilePath) else {
    print("CANNOT OPEN "  + studentsFilePath)
    exit(1)
}
guard let assignmentsFile = FileHandle(forReadingAtPath: assignmentsFilePath) else {
    print("CANNOT OPEN "  + assignmentsFilePath)
    exit(1)
}
let studentsData = studentsFile.readDataToEndOfFile()
let assignmentsData = assignmentsFile.readDataToEndOfFile()
// Convert the data to strings
guard let studentsStr = String(data: studentsData, encoding: .utf8) else {
    print("CANNOT CONVERT " + studentsFilePath + " DATA TO A STRING")
    exit(1)
}
guard let assignmentsStr = String(data: assignmentsData, encoding: .utf8) else {
    print("CANNOT CONVERT " + assignmentsFilePath + " DATA TO A STRING")
    exit(1)
}
// Create list to store all the student names
let studentsList = studentsStr.components(separatedBy: .newlines)
// Create list to store all the assignment names
let assignmentsList = assignmentsStr.components(separatedBy: .newlines)
// Generate the marks table
let marksTable = generateMarks(studentsList, assignmentsList)
// Upload table to CSV file
// Create string for the CSV content
var csvString: String = ""
for row in marksTable {
    csvString += row.joined(separator: ",") + "\n"
}
// Access the output file for writing
guard let outputFile = FileHandle(forWritingAtPath: outputFilePath) else {
    print("CANNOT OPEN " + outputFilePath + " FOR WRITING")
    exit(1)
}
// Helper function for writing data
func writeToOutputFile(_ text: String) {
    if let data = text.data(using: .utf8) {
        outputFile.write(data)
    } else {
        print("Error: WRITING FAILED")
    }
}
// Write the CSV string to the output file
writeToOutputFile(csvString)
print("DONE!")