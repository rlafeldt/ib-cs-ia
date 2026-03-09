// Importing necessary Dart and Flutter packages
import 'dart:io';
import 'package:app_cs/models/claim.dart';

import 'package:open_file/open_file.dart';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

// Class to handle Spreadsheet file operations
class ExcelApi {
  // Method to create and download an Excel file for a given Claim object
  Future<void> downloadClaim(Claim claim) async {
    // Creating a new Excel document
    var excel = Excel.createExcel();
    // Accessing or creating a sheet named after the Claim's process ID
    Sheet sheetObject = excel['Claim #${claim.processID}'];

    // Setting a default cell style with Calibri font
    CellStyle cellStyle =
        CellStyle(fontFamily: getFontFamily(FontFamily.Calibri));

    // Headers for the Excel sheet columns
    List<String> header = [
      "Process Number",
      "Principal Value",
      "Execution Process Start Date",
      "Execution Process End Date",
      "Interest Rate",
      "Fees",
      "First Name",
      "Last Name",
      "Base Date",
      "Amount Paid",
      "Future Value",
      "Profit",
    ];

    // Values to be inserted into the Excel sheet, derived from the Claim object
    List values = [
      claim.processID,
      claim.principalValue,
      claim.executionProcessStartDate,
      claim.executionProcessEndDate,
      claim.interestRate,
      claim.fees,
      claim.firstName,
      claim.lastName,
      claim.baseDate,
      claim.amountPaid,
      claim.futureValue,
      claim.profit,
    ];

    // Excel cell references for headers and values
    List headerCoordinates = [
      "A1",
      "B1",
      "C1",
      "D1",
      "E1",
      "F1",
      "G1",
      "H1",
      "I1",
      "J1",
      "K1",
      "L1",
    ];
    List valueCoordinates = [
      "A2",
      "B2",
      "C2",
      "D2",
      "E2",
      "F2",
      "G2",
      "H2",
      "I2",
      "J2",
      "K2",
      "L2",
    ];

    // Looping through coordinates to set headers and values in the sheet
    for (int i = 0; i < valueCoordinates.length; i++) {
      sheetObject.cell(CellIndex.indexByString(headerCoordinates[i]))
        ..value = header[i] // Setting header value
        ..cellStyle = cellStyle; // Applying cell style
      sheetObject.cell(CellIndex.indexByString(valueCoordinates[i]))
        ..value = values[i] // Setting data value
        ..cellStyle = cellStyle; // Applying cell style
    }

    // Saving the Excel document to a byte array
    var fileBytes = excel.save();

    final dir = await getApplicationDocumentsDirectory();

    try {
      // Writing the Excel file to disk with a specific filename
      File('${dir.path}/Claim_#${claim.processID}.xlsx')
        ..createSync(recursive: true) // Ensuring the file path exists
        ..writeAsBytesSync(fileBytes!); // Writing the byte array to the file

      await OpenFile.open('${dir.path}/Claim_#${claim.processID}.xlsx');
    } catch (e) {
      // Rethrowing the exception for further handling
      rethrow;
    }
  }
}
