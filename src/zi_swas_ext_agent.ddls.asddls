
extend view entity /DMO/E_Agency 
       with association to zzextenagent_swa as _zzswas 
    on $projection.AgencyId = _zzswas.agencyid       
{     
     _zzswas      
    
}












