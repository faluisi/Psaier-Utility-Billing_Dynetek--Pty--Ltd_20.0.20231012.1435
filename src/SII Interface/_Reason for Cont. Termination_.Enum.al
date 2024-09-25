enum 50236 "Reason for Cont. Termination"
{
    Extensible = true;

    value(0; " ")
    {
    Caption = ' ';
    }
    value(1; "CAE1")
    {
    Caption = 'Contractual termination (liability liability) on a point suspended due to non-payment'; //risoluzione contrattuale (r.c.) su punto sospeso per morosità
    }
    value(2; "CAE2")
    {
    Caption = 'Resolution upon request of the end customer'; //risoluzione su richiesta del cliente finale
    }
    value(3; "CAE3")
    {
    Caption = 'Contractual termination on default points for which the suspension and interruption procedures have not been successful'; //risoluzione contrattuale su punti morosi su cui le procedure di  sospensione e interruzione non sono andate a buon fine
    }
    value(4; "CAE4")
    {
    Caption = 'Contractual termination due to reconsideration of the end customer'; //risoluzione contrattuale per ripensamento cliente finale
    }
    value(5; "CAE5")
    {
    Caption = 'Contractual termination due to an unsolicited contract'; //risoluzione contrattuale per contratto non richiesto
    }
    value(6; "CAE6")
    {
    Caption = 'Contractual termination due to loss of greater protection requirements'; //risoluzione contrattuale per perdita dei requisiti di maggior tutela
    }
    value(7; "CAE7")
    {
    Caption = 'Arrears on a non-disconnectable point'; //morosità su punto non disalimentabile
    }
    value(8; "CAE8")
    {
    Caption = 'Reasons other than the previous ones'; //motivi diversi dai precedenti
    }
    value(9; "CAE9")
    {
    Caption = 'Contractual termination due to loss of the requirements for gradual protection'; //risoluzione contrattuale per perdita dei requisiti delle tutele graduali
    }
}
