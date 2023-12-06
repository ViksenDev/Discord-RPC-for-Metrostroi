-- This requires a special module to be installed before it works correctly
-- Sorry to disappoint you
if file.Find("lua/bin/gmcl_PNdiscord_*.dll", "GAME")[1] == nil then return end
require("gdiscord")

-- Configuration
local map_restrict = true -- Should a display default image be displayed if the map is not in a given list?
local map_list = {
	gm_metrostroi_b50 = true,
	gm_mus_neoorange_d = true,
	gm_mustox_neocrimson_line_a = true,
	gm_mus_loopline_e = true,
	gm_metronvl = true,
	gm_jar_pll_remastered_v12 = true,
	gm_metro_crossline_n3 = true,
	gm_metro_u6 = true,
	gm_smr_first_line = true,
	gm_metro_ruralline_v29 = true,
	gm_metro_minsk_1984 = true,
	gm_metro_jar_imagine_line_v4 = true,
	gm_metro_crossline_r199h = true,
	gm_budapest_m5 = true,
	gm_metro_surfacemetro = true,
	gm_metro_virus = true,
	gm_smr_1987 = true,
	gm_dnipro = true,
	gm_budapest_m3 = true,
	gm_metro_chapaevskaya_line_a = true, 
	gm_metro_nsk_line_2_v5 = true,
	gm_metro_mosldl_v1 = true,
	gm_metro_nekrasovskaya_line_v5 = true,
	gm_metro_kalinin_v2 = true,
	gm_metro_mosldl_v1m = true,
	gm_metro_krl_v1 = true
}
-- Add a mapping of readable names for the maps
local readable_map_names = {
	gm_metrostroi_b50 = "Первая линия",
	gm_mus_neoorange_d = "Оранжевая линия",
	gm_mustox_neocrimson_line_a = "Малиновая линия",
	gm_mus_loopline_e = "Кольцевая линия",
	gm_metronvl = = "Невско-Василеостровская линия",
	gm_jar_pll_remastered_v12 = "Петрищевско-Ленинградская линия",
	gm_metro_crossline_n3 = "Кировская линия",
	gm_metro_u6 = "Метро U6",
	gm_smr_first_line = "Кировская линия",
	gm_metro_ruralline_v29 = "Пригородная линия",
	gm_metro_minsk_1984 = "Московская линия",
	gm_metro_jar_imagine_line_v4 = "Россошанская линия",
	gm_metro_crossline_r199h = "Кировская линия",
	gm_budapest_m5 = "Budapest M5",
	gm_metro_surfacemetro = "Метро Surface",
	gm_metro_virus = "Метро Virus",
	gm_smr_1987 = "Первая линия 1987",
	gm_dnipro = "Центрально-Заводская линия",
	gm_budapest_m3 = "Budapest M3",
	gm_metro_chapaevskaya_line_a = "Чапаевская Линия",
	gm_metro_nsk_line_2_v5 = "Ленинская линия",
    gm_metro_mosldl_v1 = "Люблинско-Дмитровская Линия",
    gm_metro_nekrasovskaya_line_v5 = "Некрасовская Линия",
    gm_metro_kalinin_v2 = "Калининская Линия",
    gm_metro_mosldl_v1m = "Люблинско-Дмитровская Линия",
    gm_metro_krl_v1 = "Калужско-Рижская Линия"
}
local image_fallback = "default"
local discord_id = "TOKEN DISCORD DEV"
local refresh_time = 60
local function GetReadableMapName(map)
    return readable_map_names[map] or map
end

local discord_start = discord_start or -1

function DiscordUpdate()
    -- Determine what type of game is being played
    local rpc_data = {}
    if game.SinglePlayer() then
        rpc_data["state"] = "Singleplayer"
    else
        local ip = game.GetIPAddress()
        if ip == "loopback" then
            if GetConVar("p2p_enabled"):GetBool() then
                rpc_data["state"] = "Peer 2 Peer"
            else
                rpc_data["state"] = "Local Server"
            end
        else
            rpc_data["state"] = string.Replace("Viksen Metrostroi NoRank #1", "")
        end
    end

    -- Determine the max number of players
    rpc_data["partySize"] = player.GetCount()
    rpc_data["partyMax"] = game.MaxPlayers()
    if game.SinglePlayer() then rpc_data["partyMax"] = 0 end

    -- Handle map stuff
    -- See the config
	local current_map = game.GetMap()
    rpc_data["largeImageKey"] = current_map
    rpc_data["largeImageText"] = GetReadableMapName(current_map)

    if map_restrict and not map_list[current_map] then
        rpc_data["largeImageKey"] = image_fallback
    end

    rpc_data["details"] = GetReadableMapName(current_map)
    rpc_data["startTimestamp"] = discord_start

    DiscordUpdateRPC(rpc_data)
end

hook.Add("Initialize", "UpdateDiscordStatus", function()
    discord_start = os.time()
    DiscordRPCInitialize(discord_id)
    DiscordUpdate()

    timer.Create("DiscordRPCTimer", refresh_time, 0, DiscordUpdate)
end)

print("Current Map: " .. game.GetMap())

if map_restrict and not map_list[game.GetMap()] then
    print("Using fallback image")
end