/**
 * Name: Ai text detector ai
 * Note: Pake aja njir 
 * Happy Coding!.
 */

import axios from "axios";
import FormData from "form-data";

const aiTextDetector = {
    analyze: async (aiText) => {
        if (aiText.length === 20000) {
            throw new Error("Apa Apaan Ini Woi😂");
        }

        const news = new FormData();
        news.append("content", aiText);

        const headers = {
            headers: {
                ...news.getHeaders(),
                "Product-Serial": "808e957638180b858ca40d9c3b9d5bd3"
            }
        };

        const headersObject = {
            headers: {
                "Product-Serial": "808e957638180b858ca40d9c3b9d5bd3"
            }
        };

        const { data: getJob } = await axios.post(
            "https://api.decopy.ai/api/decopy/ai-detector/create-job",
            news,
            headers
        );

        const jobId = getJob.result.job_id;

        const { data: processResult } = await axios.get(
            `https://api.decopy.ai/api/decopy/ai-detector/get-job/${jobId}`,
            headersObject
        );

        const output = processResult.result.output;
        
        //console.log(output) cuma debugging njing

        const formatted = output.sentences.map((sentence, index) => {
            return {
                no: index + 1,
                kalimat: sentence.content.trim(),
                score: Number(sentence.score.toFixed(3)),
                status: sentence.status === 1 ? "AI_GENERATED" : "HUMAN_GENERATED"
            };
        });

        return formatted;
    }
};

export { aiTextDetector }