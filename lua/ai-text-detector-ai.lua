--[[
Name: Ai text detector ai
Note: Pake aja njir 
Happy Coding!
]]

local axios = require("lua.lib.axios")
local json = require("dkjson") -- pakai dkjson atau lunajson kalau ada

local aiTextDetector = {}

function aiTextDetector.analyze(aiText)
    if #aiText == 20000 then
        error("Apa Apaan Ini Woi😂")
    end

    local formData = {
        content = aiText
    }

    local headers = {
        ["Product-Serial"] = "808e957638180b858ca40d9c3b9d5bd3"
    }

    -- POST ke endpoint create-job
    local createRes = axios.postWithFormData(
        "https://api.decopy.ai/api/decopy/ai-detector/create-job",
        formData,
        headers
    )

    -- Decode JSON responsenya
    local createData, _, err = json.decode(createRes.data)
    if not createData or err then
        error("Gagal decode JSON dari create-job")
    end

    local jobId = createData.result.job_id
    if not jobId then
        error("Job ID tidak ditemukan")
    end

    -- GET ke endpoint get-job/{id}
    local getRes = axios.get(
        "https://api.decopy.ai/api/decopy/ai-detector/get-job/" .. jobId,
        headers
    )

    local jobData, _, err2 = json.decode(getRes.data)
    if not jobData or err2 then
        error("Gagal decode JSON dari get-job")
    end

    local output = jobData.result.output
    if not output or not output.sentences then
        error("Output tidak valid")
    end

    -- Format hasil
    local formatted = {}
    for i, sentence in ipairs(output.sentences) do
        table.insert(formatted, {
            no = i,
            kalimat = sentence.content:match("^%s*(.-)%s*$"), -- trim
            score = tonumber(string.format("%.3f", sentence.score)),
            status = sentence.status == 1 and "AI_GENERATED" or "HUMAN_GENERATED"
        })
    end

    return formatted
end

return aiTextDetector