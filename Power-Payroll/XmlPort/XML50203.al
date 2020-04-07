xmlport 50203 "Import QuickTimesheet"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Quick Timesheet";"Quick Timesheet")
            {
                AutoReplace = true;
                XmlName = 'QuickTimesheet';
                fieldelement(BranchCode;"Quick Timesheet"."Branch Code")
                {
                }
                fieldelement(ShiftCode;"Quick Timesheet"."Shift Code")
                {
                }
                fieldelement(CalendarCode;"Quick Timesheet"."Calendar Code")
                {
                }
                fieldelement(StatisticsGroup;"Quick Timesheet"."Statistics Group")
                {
                }
                fieldelement(PayRunNo;"Quick Timesheet"."Pay Run No.")
                {
                }
                fieldelement(SpecialPayNo;"Quick Timesheet"."Special Pay No.")
                {
                }
                fieldelement(EmployeeNo;"Quick Timesheet"."Employee No.")
                {
                }
                fieldelement(PayCode;"Quick Timesheet"."Pay Code")
                {
                }
                fieldelement(Unit;"Quick Timesheet".Units)
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
        MESSAGE('Quick Timesheet Imported');
    end;

    var
        QuickTimesheet : Record "Quick Timesheet";
        HRSETUP : Record "Human Resources Setup";
}

