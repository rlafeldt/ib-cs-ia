const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


// Function to calculate the future value of a claim based on its interest rate and duration
function calculateFutureValue(claim) {
    const r = claim.interestRate; // Interest rate of the claim
    const d = calculateWorkdays(claim.executionProcessStartDate, claim.executionProcessEndDate); // Duration in workdays
    const futureValue = claim.principalValue * (Math.pow((1 + (r / 100)), (d / 252))); // Compounded interest formula
    return parseFloat(futureValue);
}

// Function to calculate workdays between two dates, excluding weekends and holidays
function calculateWorkdays(startDate, endDate) {
    let start = parseDateDDMMYYYY(startDate).setHours(0, 0, 0, 0);
    let end = parseDateDDMMYYYY(endDate).setHours(0, 0, 0, 0);
    let workdays = 0;

    while (start <= end) {
        const dayOfWeek = new Date(start).getDay();
        const isWeekend = dayOfWeek === 6 || dayOfWeek === 0; // Saturday or Sunday
        const isHoliday = holidays1.includes(start) || holidays2.includes(start) || holidays3.includes(start);

        if (!isWeekend && !isHoliday) {
            workdays++;
        }

        start = new Date(start).setDate(new Date(start).getDate() + 1); // Move to the next day
        start = new Date(start).setHours(0, 0, 0, 0); // Normalize time for comparison
    }
    return workdays;
}

// Function to calculate the number of days between two dates
function calculateDays(startDate, endDate) {
    const differenceInMilliseconds = new Date(endDate).getTime() - new Date(startDate).getTime();
    const differenceInDays = differenceInMilliseconds / (1000 * 60 * 60 * 24);

    return differenceInDays;
}

// Function to parse a date string in DD/MM/YYYY format into a Date object
function parseDateDDMMYYYY(dateString) {
    const parts = dateString.split('/');
    const day = parseInt(parts[0], 10);
    const month = parseInt(parts[1], 10) - 1; // JS months are 0-indexed
    const year = parseInt(parts[2], 10);
    return new Date(year, month, day);
}


// Arrays containing dates of holidays, which are parsed and normalized
const holidays1 = [
    "01/01/2001", "26/02/2001", "27/02/2001", "13/04/2001", "21/04/2001", "01/05/2001", "14/06/2001", "07/09/2001", "12/10/2001", "02/11/2001", "15/11/2001", "25/12/2001", "01/01/2002", "11/02/2002", "12/02/2002", "29/03/2002", "21/04/2002", "01/05/2002", "30/05/2002", "07/09/2002", "12/10/2002", "02/11/2002", "15/11/2002", "25/12/2002", "01/01/2003", "03/03/2003", "04/03/2003", "18/04/2003", "21/04/2003", "01/05/2003", "19/06/2003", "07/09/2003", "12/10/2003", "02/11/2003", "15/11/2003", "25/12/2003", "01/01/2004", "23/02/2004", "24/02/2004", "09/04/2004", "21/04/2004", "01/05/2004", "10/06/2004", "07/09/2004", "12/10/2004", "02/11/2004", "15/11/2004", "25/12/2004", "01/01/2005", "07/02/2005", "08/02/2005", "25/03/2005", "21/04/2005", "01/05/2005", "26/05/2005", "07/09/2005", "12/10/2005", "02/11/2005", "15/11/2005", "25/12/2005", "01/01/2006", "27/02/2006", "28/02/2006", "14/04/2006", "21/04/2006", "01/05/2006", "15/06/2006", "07/09/2006", "12/10/2006", "02/11/2006", "15/11/2006", "25/12/2006", "01/01/2007", "19/02/2007", "20/02/2007", "06/04/2007", "21/04/2007", "01/05/2007", "07/06/2007", "07/09/2007", "12/10/2007", "02/11/2007", "15/11/2007", "25/12/2007", "01/01/2008", "04/02/2008", "05/02/2008", "21/03/2008", "21/04/2008", "01/05/2008", "22/05/2008", "07/09/2008", "12/10/2008", "02/11/2008", "15/11/2008", "25/12/2008", "01/01/2009", "23/02/2009", "24/02/2009", "10/04/2009", "21/04/2009", "01/05/2009", "11/06/2009", "07/09/2009", "12/10/2009", "02/11/2009", "15/11/2009", "25/12/2009", "01/01/2010", "15/02/2010", "16/02/2010", "02/04/2010", "21/04/2010", "01/05/2010", "03/06/2010", "07/09/2010", "12/10/2010", "02/11/2010", "15/11/2010", "25/12/2010", "01/01/2011", "07/03/2011", "08/03/2011", "21/04/2011", "22/04/2011", "01/05/2011", "23/06/2011", "07/09/2011", "12/10/2011", "02/11/2011", "15/11/2011", "25/12/2011", "01/01/2012", "20/02/2012", "21/02/2012", "06/04/2012", "21/04/2012", "01/05/2012", "07/06/2012", "07/09/2012", "12/10/2012", "02/11/2012", "15/11/2012", "25/12/2012", "01/01/2013", "11/02/2013", "12/02/2013", "29/03/2013", "21/04/2013", "01/05/2013", "30/05/2013", "07/09/2013", "12/10/2013", "02/11/2013", "15/11/2013", "25/12/2013", "01/01/2014", "03/03/2014", "04/03/2014", "18/04/2014", "21/04/2014", "01/05/2014", "19/06/2014", "07/09/2014", "12/10/2014", "02/11/2014", "15/11/2014", "25/12/2014", "01/01/2015", "16/02/2015", "17/02/2015", "03/04/2015", "21/04/2015", "01/05/2015", "04/06/2015", "07/09/2015", "12/10/2015",
].map(parseDateDDMMYYYY).map(date => date.setHours(0, 0, 0, 0)); // Convert to Date objects and normalize time


const holidays2 = ["02/11/2015", "15/11/2015", "25/12/2015", "01/01/2016", "08/02/2016", "09/02/2016", "25/03/2016", "21/04/2016", "01/05/2016", "26/05/2016", "07/09/2016", "12/10/2016", "02/11/2016", "15/11/2016", "25/12/2016", "01/01/2017", "27/02/2017", "28/02/2017", "14/04/2017", "21/04/2017", "01/05/2017", "15/06/2017", "07/09/2017", "12/10/2017", "02/11/2017", "15/11/2017", "25/12/2017", "01/01/2018", "12/02/2018", "13/02/2018", "30/03/2018", "21/04/2018", "01/05/2018", "31/05/2018", "07/09/2018", "12/10/2018", "02/11/2018", "15/11/2018", "25/12/2018", "01/01/2019", "04/03/2019", "05/03/2019", "19/04/2019", "21/04/2019", "01/05/2019", "20/06/2019", "07/09/2019", "12/10/2019", "02/11/2019", "15/11/2019", "25/12/2019", "01/01/2020", "24/02/2020", "25/02/2020", "10/04/2020", "21/04/2020", "01/05/2020", "11/06/2020", "07/09/2020", "12/10/2020", "02/11/2020", "15/11/2020", "25/12/2020", "01/01/2021", "15/02/2021", "16/02/2021", "02/04/2021", "21/04/2021", "01/05/2021", "03/06/2021", "07/09/2021", "12/10/2021", "02/11/2021", "15/11/2021", "25/12/2021", "01/01/2022", "28/02/2022", "01/03/2022", "15/04/2022", "21/04/2022", "01/05/2022", "16/06/2022", "07/09/2022", "12/10/2022", "02/11/2022", "15/11/2022", "25/12/2022", "01/01/2023", "20/02/2023", "21/02/2023", "07/04/2023", "21/04/2023", "01/05/2023", "08/06/2023", "07/09/2023", "12/10/2023", "02/11/2023", "15/11/2023", "25/12/2023", "01/01/2024", "12/02/2024", "13/02/2024", "29/03/2024", "21/04/2024", "01/05/2024", "30/05/2024", "07/09/2024", "12/10/2024", "02/11/2024", "15/11/2024", "20/11/2024", "25/12/2024", "01/01/2025", "03/03/2025", "04/03/2025", "18/04/2025", "21/04/2025", "01/05/2025", "19/06/2025", "07/09/2025", "12/10/2025", "02/11/2025", "15/11/2025", "20/11/2025", "25/12/2025", "01/01/2026", "16/02/2026", "17/02/2026", "03/04/2026", "21/04/2026", "01/05/2026", "04/06/2026", "07/09/2026",
].map(parseDateDDMMYYYY).map(date => date.setHours(0, 0, 0, 0)); // Convert to Date objects and normalize time

const holidays3 = ["12/10/2026", "02/11/2026", "15/11/2026", "20/11/2026", "25/12/2026", "01/01/2027", "08/02/2027", "09/02/2027", "26/03/2027", "21/04/2027", "01/05/2027", "27/05/2027", "07/09/2027", "12/10/2027", "02/11/2027", "15/11/2027", "20/11/2027", "25/12/2027", "01/01/2028", "28/02/2028", "29/02/2028", "14/04/2028", "21/04/2028", "01/05/2028", "15/06/2028", "07/09/2028", "12/10/2028", "02/11/2028", "15/11/2028", "20/11/2028", "25/12/2028", "01/01/2029", "12/02/2029", "13/02/2029", "30/03/2029", "21/04/2029", "01/05/2029", "31/05/2029", "07/09/2029", "12/10/2029", "02/11/2029", "15/11/2029", "20/11/2029", "25/12/2029", "01/01/2030", "04/03/2030", "05/03/2030", "19/04/2030", "21/04/2030", "01/05/2030", "20/06/2030", "07/09/2030", "12/10/2030", "02/11/2030", "15/11/2030", "20/11/2030", "25/12/2030"
].map(parseDateDDMMYYYY).map(date => date.setHours(0, 0, 0, 0)); // Convert to Date objects and normalize time



// Function to calculate the profit from a claim
function calculateProfit(futureValue, fees, amountPaid) {
    const profit = futureValue - (futureValue * (fees / 100)) - amountPaid; // Profit formula
    return parseFloat(profit);
}


// Cloud Function triggered when a new claim document is created in Firestore
exports.calculateNewClaim = functions.firestore
    .document('claims/{claimId}')
    .onCreate((snap, context) => {
        const claim = snap.data(); // Get the newly created claim data

        const futureValue = calculateFutureValue(claim); // Calculate future value
        const profit = calculateProfit(futureValue, claim.fees, claim.amountPaid); // Calculate profit

        // Update the corresponding document in 'calculatedClaims' collection with future value and profit
        return admin.firestore().collection('calculatedClaims')
            .doc(context.params.claimId)
            .set({
                ...claim,
                futureValue: parseFloat(futureValue),
                profit: parseFloat(profit),
            });
    });


// Cloud Function triggered when a claim document is updated in Firestore
exports.updateClaim = functions.firestore
    .document('claims/{claimId}')
    .onUpdate((change, context) => {
        const claim = change.after.data();  // Get the updated claim data

        const futureValue = calculateFutureValue(claim); // Recalculate future value in case values change
        const profit = calculateProfit(futureValue, claim.fees, claim.amountPaid); // Recalculate profit

        // Update the corresponding document in 'calculatedClaims' collection with new future value and profit
        return admin.firestore().collection('calculatedClaims')
            .doc(context.params.claimId)
            .update({
                ...claim,
                futureValue: parseFloat(futureValue),
                profit: parseFloat(profit),
            });
    });

