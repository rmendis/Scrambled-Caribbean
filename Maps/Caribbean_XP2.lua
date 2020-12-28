-- Caribbean_XP2
-- Author: blkbutterfly74
-- DateCreated: 12/28/2020 1:21:50 PM
-- Creates a Huge map shaped like real-world Caribbean
-- based off SEA map scripts
-- Thanks to Firaxis
-----------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"
include "MountainsCliffs"
include "RiversLakes"
include "FeatureGenerator"
include "TerrainGenerator"
include "NaturalWonderGenerator"
include "ResourceGenerator"
include "CoastalLowlands"
include "AssignStartingPlots"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local g_iNumTotalLandTiles = 0; 
local g_CenterX = 72;
local g_CenterY = 68;
local featuregen = nil;

local landStrips = {
		{0, 28, 33},
		{1, 28, 34},
		{2, 29, 34},
		{3, 29, 34},
		{3, 39, 41},
		{3, 43, 43},
		{4, 30, 34},
		{4, 43, 44},
		{5, 30, 34},
		{5, 43, 43},
		{6, 31, 34},
		{7, 32, 33},
		{7, 45, 45},
		{8, 32, 33},
		{8, 40, 41},
		{9, 30, 30},
		{9, 40, 41},
		{9, 46, 46},
		{10, 30, 30},
		{10, 40, 41},
		{10, 48, 48},
		{11, 41, 41},
		{12, 42, 42},
		{13, 42, 42},
		{13, 46, 47},
		{14, 49, 49},
		{15, 25, 33},
		{15, 50, 50},
		{16, 23, 35},
		{16, 52, 53},
		{17, 22, 25},
		{17, 29, 36},
		{17, 39, 40},
		{17, 53, 53},
		{17, 56, 56},
		{18, 20, 22},
		{18, 30, 41},
		{19, 9, 10},
		{19, 25, 26},
		{19, 34, 42},
		{19, 59, 60},
		{20, 4, 13},
		{20, 25, 26},
		{20, 28, 28},
		{20, 37, 37},
		{20, 39, 43},
		{20, 61, 61},
		{21, 3, 13},
		{21, 40, 46},
		{21, 56, 56},
		{22, 2, 12},
		{22, 40, 48},
		{22, 55, 56},
		{23, 2, 11},
		{23, 13, 13},
		{23, 41, 50},
		{24, 2, 10},
		{24, 44, 52},
		{25, 2, 10},
		{25, 42, 53},
		{25, 57, 57},
		{26, 1, 10},
		{26, 42, 42},
		{26, 55, 66},
		{27, 0, 10},
		{27, 58, 66},
		{27, 68, 68},
		{28, 0, 10},
		{28, 58, 69},
		{29, 0, 10},
		{29, 56, 71},
		{30, 0, 9},
		{30, 52, 54},
		{30, 58, 66},
		{30, 69, 71},
		{30, 75, 79},
		{31, 0, 8},
		{31, 40, 45},
		{31, 53, 63},
		{31, 65, 65},
		{31, 76, 79},
		{31, 92, 92},
		{32, 0, 8},
		{32, 41, 46},
		{32, 61, 62},
		{33, 0, 7},
		{33, 92, 92},
		{34, 0, 7},
		{34, 91, 91},
		{35, 0, 7},
		{35, 93, 93},
		{36, 0, 7},
		{36, 93, 93},
		{37, 0, 6},
		{38, 0, 5},
		{38, 94, 94},
		{39, 0, 20},
		{40, 0, 21},
		{41, 0, 23},
		{41, 95, 95},
		{42, 0, 23},
		{43, 0, 23},
		{44, 2, 23},
		{44, 95, 95},
		{45, 3, 22},
		{46, 6, 22},
		{46, 95, 95},
		{47, 7, 8},
		{47, 10, 22},
		{48, 11, 22},
		{49, 11, 22},
		{49, 94, 94},
		{50, 12, 22},
		{50, 93, 93},
		{51, 13, 21},
		{51, 61, 62},
		{51, 67, 67},
		{51, 70, 70},
		{51, 84, 84},
		{52, 14, 21},
		{52, 97, 97},
		{52, 60, 62},
		{52, 66, 67},
		{52, 97, 97},
		{53, 15, 21},
		{53, 58, 61},
		{53, 67, 70},
		{54, 16, 21},
		{54, 57, 60},
		{54, 66, 71},
		{54, 82, 82},
		{54, 86, 86},
		{54, 95, 96},
		{55, 17, 21},
		{55, 54, 61},
		{55, 64, 72},
		{55, 88, 91},
		{55, 95, 96},
		{56, 16, 22},
		{56, 51, 72},
		{56, 78, 79},
		{56, 86, 91},
		{57, 16, 22},
		{57, 50, 81},
		{57, 84, 94},
		{58, 19, 23},
		{58, 49, 96},
		{59, 20, 24},
		{59, 49, 96},
		{60, 21, 25},
		{60, 49, 96},
		{61, 22, 26},
		{61, 35, 39},
		{61, 48, 99},
		{62, 23, 28},
		{62, 32, 35},
		{62, 38, 41},
		{62, 47, 100},
		{63, 24, 34},
		{63, 39, 42},
		{63, 46, 100},
		{64, 27, 33},
		{64, 40, 43},
		{64, 45, 100},
		{65, 29, 32},
		{65, 40, 100},
		{66, 31, 33},
		{66, 41, 100},
		{67, 32, 32},
		{67, 41, 100},
		{68, 42, 100}};

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Caribbean Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = 0;

	--	local world_age
	local world_age_new = 5;
	local world_age_normal = 3;
	local world_age_old = 2;

	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = world_age_normal;	-- default
	end
	
	plotTypes = GeneratePlotTypes(world_age);
	terrainTypes = GenerateTerrainTypesCaribbean(plotTypes, g_iW, g_iH, g_iFlags, false);
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);

	AreaBuilder.Recalculate();
	--[[ blackbutterfly74 - Why this additional AnalyzeChockepoint()? Commenting out for now:
	TerrainBuilder.AnalyzeChokepoints(); --]]
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots);

	AreaBuilder.Recalculate();

	-- Place lakes before rivers so they may act as river sources
	local numLargeLakes = math.floor(GameInfo.Maps[Map.GetMapSize()].Continents * 0.3);
	AddLakes(numLargeLakes);

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();

	AddFeatures();

	TerrainBuilder.AnalyzeChokepoints();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};

	local nwGen = NaturalWonderGenerator.Create(args);

	AddFeaturesFromContinents();
	MarkCoastalLowlands();
	
	local resourcesConfig = MapConfiguration.GetValue("resources");
	local args = {
		resources = resourcesConfig,
		iWaterLux = 4,
	}
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 85,
		MIN_MINOR_CIV_FERTILITY = 5, 
		MIN_BARBARIAN_FERTILITY = 1,
		START_MIN_Y = 15,
		START_MAX_Y = 15,
		WATER = true,
		START_CONFIG = startConfig,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-- Input a Hash; Export width, height, and wrapX
function GetMapInitData(MapSize)
	local Width = 101;
	local Height = 68;
	local WrapX = false;
	return {Width = Width, Height = Height, WrapX = WrapX,}
end
-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};

	-- Start with it all as water
	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_OCEAN;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
		end
	end

	-- Each land strip is defined by: Y, X Start, X End
	local xOffset = 0;
	local yOffset = 0;
		
	for i, v in ipairs(landStrips) do
		local y = g_iH - (v[1] + yOffset);   -- inverted
		local xStart = v[2] + xOffset;
		local xEnd = v[3] + xOffset; 
		for x = xStart, xEnd do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_LAND;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_GRASS);  -- temporary setting so can calculate areas
			g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
		end
	end
		
	AreaBuilder.Recalculate();
	
	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 10;
	args.blendFract = 1;
	args.extra_mountains = 4;
	plotTypes = ApplyTectonics(args, plotTypes);

	return plotTypes;
end

function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};
	
	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end
	
	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end
	
	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);	
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
	added some minor randomness and the slope might be a little tricky. It was 
	intended as a 'whole world' modifier to the fractal class. You can modify 
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end

	local args = {rainfall = rainfall, iJunglePercent = 70, iMarshPercent = 12, iForestPercent = 9, iReefPercent = 15}	-- jungle & marsh max coverage
	featuregen = FeatureGenerator.Create(args);

	featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);

	-- add rainforest more densely at center
	for iX = 0, g_iW - 1 do
		for iY = 0, g_iH - 1 do
			local index = (iY * g_iW) + iX;
			local plot = Map.GetPlot(iX, iY);
			local iDistanceFromCenter = Map.GetPlotDistance (iX, iY, g_CenterX, g_CenterY);

			if (plot:GetFeatureType() == g_FEATURE_FLOODPLAINS) then
				-- 50/50 chance to add floodplains when get 20 tiles out.  Linear scale out to there
				if (TerrainBuilder.GetRandomNumber(40, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					TerrainBuilder.SetFeatureType(plot, -1);
				end
			else
				-- add rainforest more densely at center. Inverse of floolplain logic
				if (TerrainBuilder.GetRandomNumber(45, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					featuregen:AddJunglesAtPlot(plot, iX, iY);
				-- add forest more densely at center. Inverse of floolplain logic
				elseif (TerrainBuilder.GetRandomNumber(55, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					featuregen:AddForestsAtPlot(plot, iX, iY);
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function GenerateTerrainTypesCaribbean(plotTypes, iW, iH, iFlags, bNoCoastalMountains)
	print("Generating Terrain Types");
	local terrainTypes = {};

	local fracXExp = -1;
	local fracYExp = -1;
	local grain_amount = 3;

	grass = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
									
	iGrassTop = grass:GetHeight(100);
	iGrassBottom = grass:GetHeight(30);

	plains = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
																		
	iPlainsTop = plains:GetHeight(100);
	iPlainsBottom = plains:GetHeight(35);

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			if (plotTypes[index] == g_PLOT_TYPE_OCEAN) then
				if (IsAdjacentToLand(plotTypes, iX, iY)) then
					terrainTypes[index] = g_TERRAIN_TYPE_COAST;
				else
					terrainTypes[index] = g_TERRAIN_TYPE_OCEAN;
				end
			end
		end
	end

	if (bNoCoastalMountains == true) then
		plotTypes = RemoveCoastalMountains(plotTypes, terrainTypes);
	end

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;

			local iDistanceFromCenter = Map.GetPlotDistance (iX, iY, g_CenterX, g_CenterY);

			if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
				terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;

				local grassVal = grass:GetHeight(iX, iY);
				local plainsVal = plains:GetHeight(iX, iY);
				if ((grassVal >= iGrassBottom) and (grassVal <= iGrassTop)) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
				elseif ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
					terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
				end

			elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
				terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
		
				local grassVal = grass:GetHeight(iX, iY);
				local plainsVal = plains:GetHeight(iX, iY);
				if ((grassVal >= iGrassBottom) and (grassVal <= iGrassTop)) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				elseif ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
					terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
				end
			end
		end
	end

	local bExpandCoasts = true;

	if bExpandCoasts == false then
		return
	end

	print("Expanding coasts");
	for iI = 0, 2 do
		local shallowWaterPlots = {};
		for iX = 0, iW - 1 do
			for iY = 0, iH - 1 do
				local index = (iY * iW) + iX;
				if (terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					-- Chance for each eligible plot to become an expansion is 1 / iExpansionDiceroll.
					-- Default is two passes at 1/4 chance per eligible plot on each pass.
					if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(4, "add shallows") == 0) then
						table.insert(shallowWaterPlots, index);
					end
				end
			end
		end
		for i, index in ipairs(shallowWaterPlots) do
			terrainTypes[index] = g_TERRAIN_TYPE_COAST;
		end
	end
	
	return terrainTypes; 
end
------------------------------------------------------------------------------
function FeatureGenerator:AddIceToMap()
	return false, 0;
end

------------------------------------------------------------------------------
function CustomGetMultiTileFeaturePlotList(pPlot, eFeatureType, aPlots)

	-- First check this plot itself
	if (not TerrainBuilder.CanHaveFeature(pPlot, eFeatureType, true)) then
		return false;
	else
		table.insert(aPlots, pPlot:GetIndex());
	end

	-- Which type of custom placement is it?
	local customPlacement = GameInfo.Features[eFeatureType].CustomPlacement;

	-- 6 tiles in a straight line
	if (customPlacement == "PLACEMENT_REEF_EXTENDED") then

		for i = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
			local pPlots = {};
			local iNumFound = 1;	
			local bBailed = false;			
			pPlots[iNumFound] = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), i);
			if (pPlots[iNumFound] ~= nil and TerrainBuilder.CanHaveFeature(pPlots[iNumFound], eFeatureType, true)) then

				while iNumFound < 5 do
					iNumFound = iNumFound + 1;
					pPlots[iNumFound] = Map.GetAdjacentPlot(pPlots[iNumFound - 1]:GetX(), pPlots[iNumFound - 1]:GetY(), i);
					if (pPlots[iNumFound] == nil) then
						bBailed = true;
						break;
					elseif not TerrainBuilder.CanHaveFeature(pPlots[iNumFound], eFeatureType, true) then
						bBailed = true;
						break;
					end
				end

				if not bBailed then
					for j = 1, 5 do
						table.insert(aPlots, pPlots[j]:GetIndex());
					end
					print ("Found valid Extended Barrier Reef location at: " .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()));
					return true;
				end
			end
		end
	end

	return false;
end

------------------------------------------------------------------------------
function FeatureGenerator:AddReefAtPlot(plot, iX, iY)
	--Reef Check. First see if it can place the feature.
	local lat = math.abs((self.iGridH/2) - iY)/(self.iGridH/2)
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF) and lat < self.iceLat * 0.9) then
		self.iNumReefablePlots = self.iNumReefablePlots + 1;
		if(math.ceil(self.iReefCount * 100 / self.iNumReefablePlots) <= self.iReefMaxPercent) then
				--Weight based on adjacent plots
				local iScore  = 3 * math.abs(iY - self.iNumEquator);
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_REEF);

				if(iAdjacent == 0 ) then
					iScore = iScore + 100;
				elseif(iAdjacent == 1) then
					iScore = iScore + 125;
				elseif (iAdjacent == 2) then
					iScore = iScore  + 150;
				elseif (iAdjacent == 3 or iAdjacent == 4) then
					iScore = iScore + 175;
				else
					iScore = iScore + 10000;
				end

				if(TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") >= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_REEF);
					self.iReefCount = self.iReefCount + 1;
				end
		end
	end
end

-- override: southern forest bias
function FeatureGenerator:AddForestsAtPlot(plot, iX, iY)
	--Forest Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FOREST)) then
		if(math.ceil(self.iForestCount * 100 / self.iNumLandPlots) <= self.iForestMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 3 * (1 - iY/g_iH) * 100;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_FOREST);

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);
				self.iForestCount = self.iForestCount + 1;
			end
		end
	end
end

-- override: more northern jungle
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY)
	--Jungle Check. First see if it can place the feature.
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE)) then
		if(math.ceil(self.iJungleCount * 100 / self.iNumLandPlots) <= self.iJungleMaxPercent) then

			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 350 * (iY + 1);    -- co-ordinate system starts at zero
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JUNGLE);

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end

			if(TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
				local terrainType = plot:GetTerrainType();

				if(terrainType == g_TERRAIN_TYPE_PLAINS_HILLS or terrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
					TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS_HILLS);
				else
					TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS);
				end

				self.iJungleCount = self.iJungleCount + 1;
				return true;
			end

		end
	end

	return false
end

------------------------------------------------------------------------------
function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end