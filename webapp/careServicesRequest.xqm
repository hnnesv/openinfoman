module namespace page = 'http://basex.org/modules/web-page';

import module namespace csr_proc = "https://github.com/his-interop/openinfoman/csr_proc" at "../repo/csr_processor.xqm";
import module namespace csd_dm = "https://github.com/his-interop/openinfoman/csd_dm" at "../repo/csd_document_manager.xqm";
import module namespace request = "http://exquery.org/ns/request";

declare   namespace   csd = "urn:ihe:iti:csd:2013";
declare default element  namespace   "urn:ihe:iti:csd:2013";


declare variable $page:db := 'provider_directory';
declare variable $page:csd_docs := csd_dm:registered_documents($page:db);

declare
  %rest:path("/CSD/csr/{$name}/careServicesRequest")
  %rest:consumes("application/xml", "text/xml", "multipart/form-data")
  %rest:POST("{$careServicesRequest}")
  function page:csr($name,$careServicesRequest) 
{ 
if (csd_dm:document_source_exists($page:db,$name)) then 
 csr_proc:process_CSR($careServicesRequest/careServicesRequest,csd_dm:open_document($page:db,$name))   
else
  (:need appropriate error handling:)
  ()

};


declare
  %rest:path("/CSD/csr")
  %rest:GET
  %output:method("xhtml")
  function page:csr_list() 
{ 
let $response := 
  <span>
    <h2>Care Services Request</h2>
    <ul>
      {
	for $name in $page:csd_docs
	return 
	<li>
	  Submit Care Services Request for {$name} at:
	  <pre>{request:scheme()}://{request:hostname()}:{request:port()}//CSD/csr/{$name}/careServicesRequest</pre> 
	</li>
      }
    </ul>
  </span>
  return page:wrapper($response)
};


declare function page:wrapper($response) {
 <html>
  <head>

    <link href="{request:scheme()}://{request:hostname()}:{request:port()}/static/bootstrap/css/bootstrap.css" rel="stylesheet"/>
    <link href="{request:scheme()}://{request:hostname()}:{request:port()}/static/bootstrap/css/bootstrap-theme.css" rel="stylesheet"/>
    

    <script src="https://code.jquery.com/jquery.js"/>
    <script src="{request:scheme()}://{request:hostname()}:{request:port()}/static/bootstrap/js/bootstrap.min.js"/>

    <script src="https://code.jquery.com/jquery.js"/>
    <script src="{request:scheme()}://{request:hostname()}:{request:port()}/static/bootstrap/js/bootstrap.min.js"/>
  </head>
  <body>  
    <div class="navbar navbar-inverse navbar-static-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="{request:scheme()}://{request:hostname()}:{request:port()}/CSD">OpenInfoMan</a>
        </div>
      </div>
    </div>
    <div class='container'>  {$response}</div>
  </body>
 </html>
};







