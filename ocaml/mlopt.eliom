{shared{
  open Eliom_lib
  open Eliom_content
}}

module Mlopt_app =
  Eliom_registration.App (
    struct
      let application_name = "mlopt"
    end)

let main_service =
  Eliom_service.service ~path:[] ~get_params:Eliom_parameter.unit ()

let () =
  Mlopt_app.register
    ~service:main_service
    (fun () () ->
      Lwt.return
        (Eliom_tools.F.html
           ~title:"mlopt"
           ~css:[["css";"mlopt.css"]]
           Html5.F.(body [
             h2 [pcdata "Welcome from Eliom's destillery!"];
           ])))
