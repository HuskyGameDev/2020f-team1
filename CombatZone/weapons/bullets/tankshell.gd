extends "res://weapons/bullets/projectiles.gd"

func _on_projectiles_body_entered(body: Node) -> void:
    print("bullet hit")
    if body.get_groups().has("flesh_damageable"):
        #if is player and is embarked we should do extra damage.
        
        #Sound stop is jarring, but resource management is more tedious.
        #self.hide()
        print(body.get_name())
        do_base_dmg(body)
        Global.create_explosion(global_position)    
        queue_free()
        pass
    #Now allow for collision with tilemaps	
    if body.get_class() == "TileMap":
        #Again, the Sound stop is jarring, but resource management is more tedious.
        #self.hide()
        Global.create_explosion(global_position)    
        queue_free()
pass

func do_base_dmg(body):
    body.take_damage(global_position, damage)
    pass
    
