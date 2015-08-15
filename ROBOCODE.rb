class Kopylov <RTanque::Bot::Brain
     # The tick! function is called every frame. (30x per second)
       # This is the heart of your tank.
  def tick!
    @angle_modifier ||= 0
    @counter ||= 0
    @last_enemy_position ||= Point.new(1,1, self.arena)
    make_circles
    if self.sensors.radar.count == 0
      command.radar_heading = sensors.radar_heading + RTanque::Heading.new_from_degrees(30)
      command.turret_heading = sensors.turret_heading + RTanque::Heading.new_from_degrees(30)
    else
      closest_reflection = self.sensors.radar.min { |a,b| a.distance<=>b.distance }
      command.radar_heading = closest_reflection.heading
      command.turret_heading = closest_reflection.heading +  RTanque::Heading.new_from_degrees(@angle_modifier)
      command.fire (MAX_FIRE_POWER)
      
      enemy_point = closest_reflection.enemy_position
      if (@last_enemy_position.x == enemy_point.x && @last_enemy_position.y == enemy_point.y)
        @angle_modifier = 0
      elsif (@counter == 150)
        @counter = 0
        @angle_modifier = Random.rand(16) - 8
        puts @angle_modifier
      else
        @counter += 1
      end
      @last_enemy_position = enemy_point
    end
  end
  
  
  def make_circles
    
          #Tells the tank to move at the maximum speed
          
    enemy_reflections = self.sensors.radar
    closest_reflection = enemy_reflections.min { |a,b| a.distance<=>b.distance }
    enemy_point = Point.new(1,1, self.arena)
    unless closest_reflection.nil?
    
      closest_reflection = enemy_reflections.min { |a,b| a.distance<=>b.distance }
      
      enemy_point = closest_reflection.enemy_position
    
    end
    if (@last_enemy_position.x == enemy_point.x && @last_enemy_position.y == enemy_point.y)
      middle = Point.new(self.arena.width/2, self.arena.height/2)
      unless (middle.within_radius?(self.sensors.position, 200))
         command.heading = RTanque::Heading.new_between_points(sensors.position, middle)      
          command.speed = MAX_BOT_SPEED 
          
      else
        if (enemy_point.y < self.arena.height/2)
          command.heading = 0
          command.speed = MAX_BOT_SPEED 
        else
          command.heading = 180
        end
      end
    else
      
      command.speed = RTanque::Bot::BrainHelper::MAX_BOT_SPEED
      
            #Tells the tank to move 85 degrees clockwise. (0 is top)
      command.heading = sensors.heading + RTanque::Heading.new_from_degrees(85)
      
            #Tells the turret to move 85 degrees counterclockwise. (0 is top)
      command.turret_heading = sensors.turret_heading - RTanque::Heading.new_from_degrees(35)
      
            # Enemy information is obtained through the radar
      unless closest_reflection.nil?
          command.heading = closest_reflection.heading- RTanque::Heading.new_from_degrees(50)
    end 
            # enemy_reflections is an Enumerator (List) of 'Reflections' of all visible tanks
      
            # You can do some cool things with Enumerators, for example to get the closest enemy
    end

  end
  
  
  
  def initialize_HealthTracker()
    health = {} #keys are Fixnum instances representing time (in ticks), values are Fixnum instances representing health (in hit points)
  end
  
end