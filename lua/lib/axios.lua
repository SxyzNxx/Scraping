local axios = {}

-- Fungsi untuk eksekusi shell dan ambil output
local function exec(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result
end

local function buildHeaders(headers)
    local headerStr = ""
    if headers then
        for k, v in pairs(headers) do
            headerStr = headerStr .. string.format("-H \"%s: %s\" ", k, v)
        end
    end
    return headerStr
end

-- Fungsi GET
function axios.get(url, headers)
    local headerStr = ""
    if headers then
        for k, v in pairs(headers) do
            headerStr = headerStr .. string.format("-H \"%s: %s\" ", k, v)
        end
    end
    local cmd = string.format("curl -s %s \"%s\"", headerStr, url)
    local response = exec(cmd)
    return {
        data = response,
        status = 200 -- dummy, bisa diperbaiki kalau mau ambil dari curl
    }
end

-- Fungsi POST
function axios.post(url, data, headers)
    local headerStr = "-H \"Content-Type: application/json\" "
    if headers then
        for k, v in pairs(headers) do
            headerStr = headerStr .. string.format("-H \"%s: %s\" ", k, v)
        end
    end
    local json = data
    if type(data) == "table" then
        -- konversi manual jadi JSON-like string
        local jsonParts = {}
        for k, v in pairs(data) do
            table.insert(jsonParts, string.format('"%s":"%s"', k, v))
        end
        json = "{" .. table.concat(jsonParts, ",") .. "}"
    end
    local cmd = string.format("curl -s -X POST %s -d '%s' \"%s\"", headerStr, json, url)
    local response = exec(cmd)
    return {
        data = response,
        status = 200
    }
end

-- Fungsi HEAD
function axios.head(url, headers)
    local cmd = string.format("curl -s -I %s \"%s\"", buildHeaders(headers), url)
    local response = exec(cmd)
    return {
        headers = response,
        status = 200
    }
end
   
-- Fungsi OPTIONS
function axios.options(url, headers) 
    local cmd = string.format("curl -s -i -X OPTIONS %s \"%s\"", buildHeaders(headers), url)
    local response = exec(cmd)
    return {
        data = response,
        status = 200
    }
end

-- Fungsi POST dengan Form Data (multipart/form-data)
function axios.postWithFormData(url, data, headers)
    local headerStr = ""
    if headers then
        for k, v in pairs(headers) do
            headerStr = headerStr .. string.format("-H \"%s: %s\" ", k, v)
        end
    end

    -- Bangun form data untuk curl (-F)
    local formStr = ""
    for k, v in pairs(data) do
        formStr = formStr .. string.format("-F \"%s=%s\" ", k, v)
    end

    local cmd = string.format("curl -s -X POST %s %s \"%s\"", headerStr, formStr, url)
    local response = exec(cmd)
    return {
        data = response,
        status = 200
    }
end

return axios