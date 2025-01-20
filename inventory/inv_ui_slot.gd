extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var tool_name: Label = $Tooltip/item_name
@onready var tool_text: Label = $Tooltip/item_text

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
		tool_name.text = "ITEM NAME"
		tool_text.text = "ITEM DISC"
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		tool_name.text = slot.item.name
		tool_text.text = slot.item.text
		
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)

func _on_center_container_mouse_entered() -> void:
	if tool_name.text == "ITEM NAME":
		$Tooltip.visible = false
	else:
		$Tooltip.visible = true
	
func _on_center_container_mouse_exited() -> void:
	$Tooltip.visible = false
