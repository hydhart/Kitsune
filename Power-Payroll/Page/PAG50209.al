page 50209 "Branch List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = Branch;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Name;Name)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        //ASHNEIL CHANDRA  13072017
        HRSETUP.GET();
        IF HRSETUP."Global FNPF Contribution" = 0 THEN BEGIN
          ERROR('Global FNPF Contribution Percentage not defined');
        END;

        IF HRSETUP."Employer FNPF Contribution" = 0 THEN BEGIN
          ERROR('Employer FNPF Contribution Percentage not defined');
        END;

        IF HRSETUP."Global Secondary Tax" = 0 THEN BEGIN
          ERROR('Global Secondary Percentage not defined');
        END;
        //ASHNEIL CHANDRA  13072017
    end;

    var
        HRSETUP : Record "Human Resources Setup";
}

