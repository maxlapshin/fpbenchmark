-module(element_notice).

-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

reflect() -> record_info(fields, notice).

render_element(Record) ->
    Type     = Record#notice.type,
    Position = Record#notice.position,
    IsShort  = Record#notice.is_short,
    Title    = Record#notice.title,
    Text     = Record#notice.body,

    Id =
    case Record#notice.id of
        undefined ->
            wf:temp_id();
        I ->
            I
    end,

    Panel = construct_body(Type, IsShort, Position, Title, Text),

    case Record#notice.delay of
        undefined ->
            ok;
        Delay ->
            wf:wire(Id, #event{type=timer, delay = Delay, actions=#fade{speed=300}})
    end,

    Panel#panel{id = Id}.


%% render notice according to type
construct_body(error, false, _, _Title, Text) ->
    body_skeleton("text-box-5", "title-2", "img-58.png", "ico-18.png", Text, "");
construct_body(error, true, _, _Title, Text) ->
    body_skeleton("text-box-5 text-box-8 short", "title-2", false, "ico-18.png", Text, "");
construct_body(info, false, _, _Title, Text) ->
    body_skeleton("text-box-7", "title-2", "img-60.png", "ico-16.png", Text, "");
construct_body(info, true, _, _Title, Text) ->
    body_skeleton("text-box-7 text-box-8 short", "title-2", false, "ico-16.png", Text, "");
construct_body(success, false, _, _Title, Text) ->
    body_skeleton("text-box-6", "title-2", "img-59.png", "ico-17.png", Text, "");
construct_body(success, true, _, _Title, Text) ->
    body_skeleton("text-box-6 text-box-8 short", "title-2", false, "ico-17.png", Text, "");
construct_body(message, _, left, Title, Text) ->
    body_skeleton("", "", "img-57.png", false,  Title, Text);
construct_body(message, _, right, Title, Text) ->
    body_skeleton("", "text-box-3","ar", "", "img-56.jpg", false, Title, Text, false);
construct_body(message, _, top, Title, Text) ->
    body_skeleton("", "text-box-2","ar", "", "img-020.gif", false, Title, Text, "Kakaranet");
construct_body(system_message, _, _, Title, Text) ->
    body_skeleton("text-box-9", "text-box-9", "img-57.png", false,  Title, Text).


body_skeleton(Class1, Class2, Image1, Image2, Title, Text) ->
    body_skeleton("holder-box2", "text-box-4", Class1, Class2, Image1, Image2, Title, Text, false).

body_skeleton(Class01, Class02, Class1, Class2, Image1, Image2, Title, Text, AddTitle) ->
    #panel{class="holder-box "++Class01, body=[
        #panel{class=lists:concat(["text-box ", Class02, " ", Class1]), body=[
            case Image1 of
                false ->
                    "";
                _ ->
                    #image{class="image png", image="/images/"++Image1, style="width=91;height=85;"}
            end,
            case AddTitle of
                false ->
                    "";
                _ ->
                    "<strong class=\"title-box\">"++AddTitle++"</strong>"
            end,
            #panel{class="box", body=[
                "<strong class=\"title "++Class2++"\">",
                case Image2 of
                    false ->
                        "";
                    _ ->
                        % not use standart image element because it adds additional class "image"
                        "<img class=\"png\" width=\"30\" height=\"32\" alt=\"#\" src=\"/images/"++Image2++"\">"
                end,
                Title,
                "</strong>",

                case Text of
                    "" ->
                        "";
                    _->
                        #p{body = Text}
                end
            ]}
        ]}
    ]}.

