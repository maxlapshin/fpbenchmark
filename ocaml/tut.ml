open Eliom_content
open Html5.D
open Eliom_parameter

module Example = Eliom_registration.App
    (struct let application_name = "example" end)

let main = Eliom_service.service
    ~path:[""]
    ~get_params:unit
    ()

let lorem = Eliom_service.service
    ~path:["lorem"]
    ~get_params:unit
    ()

let contact = Eliom_service.service
    ~path:["contact"]
    ~get_params:unit
    ()

let skeletton body_content =
    let header = h1 [pcdata "My awesome Ocsigen Website"]
    and menu = ul [li [a ~service:main [pcdata "Home"] ()];
                   li [a ~service:lorem [pcdata "Lorem Page"] ()];
                   li [a ~service:contact [pcdata "Contact me!"] ()]]
    and footer = div [pcdata "~ Made by me with Ocsigen ~"] in
    Lwt.return (html (head (title (pcdata "Page Title")) [])
                     (body [header; menu; div body_content; footer]))

let _ =

  Example.register ~service:main
    (fun () () -> skeletton [p [pcdata "Hello World! Welcome to my home page."]]);

  Example.register ~service:lorem
    (fun () () -> skeletton
      [h3 [pcdata "Lorem ipsum dolor sit amet"];
       p [pcdata "Donec id urna justo, consectetur adipiscing elit."];
       h3 [pcdata "Donec sit amet"];
        p [pcdata "Cras lacus nisl, laoreet at porta at, euismod eu libero."];
       h3 [pcdata "Nunc libero"];
        p [pcdata "At malesuada dui. Vivamus erat justo, sollicitudin eget lacinia."];
       h3 [pcdata "Fusce posuere"];
        p [pcdata "Nec, molestie lacinia leo. Etiam pellentesque purus ante."]]);

  Example.register ~service:contact
    (fun () () -> skeletton [p [pcdata "Send me an email: me@mail.com"]])
