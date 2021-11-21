from config import BNG_HOME, BNG_USER
from beamngpy import BeamNGpy, Scenario, Vehicle, Road
from beamngpy.sensors import Electrics
import time

def main():
    scenario = Scenario('tig', 'test_scenario')
    ground_level = -28.0

    # Create Road
    road_nodes = [
            (-100, 0, ground_level, 8),
            (  0, 0, ground_level, 8),
            (+100, 0, ground_level, 8)
        ]
    road = Road('tig_road_rubber_sticky', rid='straight_road')
    road.nodes.extend(road_nodes)
    scenario.add_road(road)
    direction_of_the_road = (0, 0, 1, -1)

    # Vehicle to move
    ego_position = (-80.0, -2.0, ground_level)
    ego_vehicle = Vehicle('ego', model='etk800', licence='ego', color="white")
    electrics = Electrics()
    ego_vehicle.attach_sensor('electrics', electrics)
    scenario.add_vehicle(ego_vehicle, pos=ego_position, rot=None, rot_quat=direction_of_the_road)

    # Obstacle
    parked_car_position = (0.0, -2.0, ground_level)
    parked_vehicle = Vehicle('parked', model='etk800', licence='parked', color="red")
    scenario.add_vehicle(parked_vehicle, pos=parked_car_position, rot=None, rot_quat=direction_of_the_road)

    # Load all stuffs into BeamNG
    with BeamNGpy('localhost', 64256, home=BNG_HOME, user=BNG_USER) as bng:
        bng.set_steps_per_second(60)    #60 fps
        bng.set_deterministic()
        scenario.make(bng)
        bng.load_scenario(scenario)
        bng.switch_vehicle(ego_vehicle) # Change camera
        bng.start_scenario()

        for _ in range (240):
            time.sleep(.1)
            sensors = bng.poll_sensors(ego_vehicle)
            print(sensors)

        input("Press enter when done...")

if __name__ == "__main__":
    main()