xmlport 50201 "Import Employee Elements"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    FileName = 'Import Employee Fixed Elements';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Employee Pay Table";"Employee Pay Table")
            {
                XmlName = 'EmployeePayTable';
                fieldelement(BranchCode;"Employee Pay Table"."Branch Code")
                {
                }
                fieldelement(ShiftCode;"Employee Pay Table"."Shift Code")
                {
                }
                fieldelement(CalendarCode;"Employee Pay Table"."Calendar Code")
                {
                }
                fieldelement(StatisticsGroup;"Employee Pay Table"."Statistics Group")
                {
                }
                fieldelement(EmployeeNo;"Employee Pay Table"."Employee No.")
                {
                }
                fieldelement(PayCode;"Employee Pay Table"."Pay Code")
                {
                }
                fieldelement(Rate;"Employee Pay Table".Rate)
                {
                }
                fieldelement(Units;"Employee Pay Table".Units)
                {
                }
                fieldelement(ValidFrom;"Employee Pay Table"."Valid From")
                {
                }
                fieldelement(ValidTo;"Employee Pay Table"."Valid To")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort();
    begin
        MESSAGE('Employee Elements Imported');
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        Employee : Record Employee;
        PayElementMaster : Record "Pay Element Master";
        PayRunScheduler : Record "Pay Run Scheduler";
        EmployeePayDetails : Record "Employee Pay Details";
        EmployeeTimesheet : Record "Employee Timesheet";
}

