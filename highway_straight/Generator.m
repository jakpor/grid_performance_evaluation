%Designer - Returns sensor detections
%    allData = Designer returns sensor detections in a structure
%    with time for an internally defined scenario and sensor suite.
%
%    [allData, scenario, sensors] = Designer optionally returns
%    the drivingScenario and detection generator objects.

% Generated by MATLAB(R) 9.8 (R2020a) and Automated Driving Toolbox 3.1 (R2020a).
% Generated on: 29-Sep-2020 12:08:15

% Create the drivingScenario object and ego car
[scenario, egoVehicle] = createDrivingScenario;

% Create all the sensors
sensor = createSensor(scenario);

allData = struct('Time', {}, 'ActorPoses', {}, 'ObjectDetections', {}, 'LaneDetections', {});
running = true;
while running
    
    % Generate the target poses of all actors relative to the ego vehicle
    poses = targetPoses(egoVehicle);
    time  = scenario.SimulationTime;
    
    % Generate detections for the sensor
    laneDetections = [];
    [objectDetections, numObjects, isValidTime] = sensor(poses, time);
    objectDetections = objectDetections(1:numObjects);
    
    % Aggregate all detections into a structure for later use
    allData(end + 1) = struct( ...
        'Time',       scenario.SimulationTime, ...
        'ActorPoses', actorPoses(scenario), ...
        'ObjectDetections', {objectDetections}, ...
        'LaneDetections',   {laneDetections}); %#ok<AGROW>
    
    % Advance the scenario one time step and exit the loop if the scenario is complete
    running = advance(scenario);
end

% Restart the driving scenario to return the actors to their initial positions.
restart(scenario);

% Release the sensor object so it can be used again.
release(sensor);

%%%%%%%%%%%%%%%%%%%%
% Helper functions %
%%%%%%%%%%%%%%%%%%%%

% Units used in createSensors and createDrivingScenario
% Distance/Position - meters
% Speed             - meters/second
% Angles            - degrees
% RCS Pattern       - dBsm

function sensor = createSensor(scenario)
% createSensors Returns all sensor objects to generate detections

% Assign into each sensor the physical and radar profiles for all actors
profiles = actorProfiles(scenario);
sensor = radarDetectionGenerator('SensorIndex', 1, ...
    'UpdateInterval', 0.05, ...
    'SensorLocation', [3.7 0], ...
    'DetectionProbability', 1, ...
    'HasNoise', false, ...
    'MaxNumDetectionsSource', 'Property', ...
    'MaxNumDetections', 1000, ...
    'DetectionCoordinates', 'Sensor spherical', ...
    'FalseAlarmRate', 1e-07, ...
    'AzimuthResolution', 0.1, ...
    'HasFalseAlarms', false, ...
    'RangeRateBiasFraction', 0.1, ...
    'RangeBiasFraction', 0.1, ...
    'RangeResolution', 0.1, ...
    'ReferenceRange', 150, ...
    'FieldOfView', [360 5], ...
    'ActorProfiles', profiles);
end

function [scenario, egoVehicle] = createDrivingScenario
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [-10 0 0;
    100 0 0;
    250 0 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid')
    laneMarking('Dashed')
    laneMarking('Solid')
    laneMarking('Solid')
    laneMarking('Dashed')
    laneMarking('Solid')
    laneMarking('Solid')];
lanetypes = [laneType('Shoulder')
    laneType('Driving')
    laneType('Driving')
    laneType('Border')
    laneType('Driving')
    laneType('Driving')
    laneType('Restricted')];
laneSpecification = lanespec(7, 'Width', 3.7, 'Marking', marking, 'Type', lanetypes);
road(scenario, roadCenters, 'Lanes', laneSpecification);

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Length', 4.848, ...
    'Width', 1.842, ...
    'Height', 1.517, ...
    'Position', [-10 -3.7 0], ...
    'RearOverhang', 1.119, ...
    'FrontOverhang', 0.911, ...
    'PlotColor', [0.85 0.325 0.098]);
waypoints = [-10 -3.7 0;
    160 -3.7 0];
speed = 30;
trajectory(egoVehicle, waypoints, speed);

% Add the non-ego actors
actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [120 -8.7 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [118.5 -23.7 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [113 -43.7 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [104 -63.7 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [96 -73.7 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [125 6.3 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [115 11.3 0], ...
    'PlotColor', [19 159 255] / 255);

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 0.1, ...
    'Width', 0.1, ...
    'Height', 1, ...
    'Position', [120 21.3 0], ...
    'PlotColor', [19 159 255] / 255);

end