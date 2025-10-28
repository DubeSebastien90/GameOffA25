function force_create(_x, _y) {
    return {
        x : _x,
        y : _y,
        
        // Optionnel : fonction pour ajouter une force
        add : function(_fx, _fy) {
            x += _fx;
            y += _fy;
        }
    };
}
