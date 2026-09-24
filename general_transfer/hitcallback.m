function hitcallback(src,evnt)
% Permette di nascondere o visualizzare gli elementi della legenda, cliccando
% sul nome. 
% Associa al 'click' del mouse il valore on o off
% On -> Elemento visualizzabile
% Off -> Elemento nascosto 
% ---------------------------------------------------

if strcmp(evnt.Peer.Visible,'on')
    evnt.Peer.Visible = 'off';
else 
    evnt.Peer.Visible = 'on';
end

end