extends CharacterBody2D

const speed = 30;
var dir: Vector2;

var player: CharacterBody2D;

# Chasing player variable
var chasingPlayer: bool;

func _process(delta):
	move(delta);

func move(delta):
	
	# Move randomly if not chasing player
	if chasingPlayer:
		player = Global.playerBody;
		velocity = position.direction_to(player.position) * speed;
	else:
		velocity += dir * speed * delta;
	
	move_and_slide();

# Function connected to the Timer object's signal
func _on_timer_timeout() -> void:
	# Sets a random timeout for the timer (random flying movement)
	$Timer.wait_time = choose([0.25, 0.5, 0.75, 1.0]);

	# Choose a random direction if not chasing player
	if !chasingPlayer:
		dir = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]);

# Chooses a random element from an array
func choose(randArray):
	# Shuffle array
	randArray.shuffle();
	# Return the first element
	return randArray.front();
