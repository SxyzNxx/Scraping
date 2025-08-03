import axios from "axios";
import * as cheerio from "cheerio";

async function dlKraken(url) {
  try {
    const { data: html } = await axios.get(url, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
      },
    });

    const $ = cheerio.load(html);
    const fileTitle = $("div.coin-info h5").text().trim();
    const videoUrl = $("video").attr("data-src-url");

    if (!videoUrl) {
      throw new Error("Video URL tidak ditemukan di halaman tersebut.");
    }

    return {
      title: fileTitle,
      url: videoUrl,
    };
  } catch (err) {
    console.error("Gagal mengambil data:", err.message);
    return null;
  }
}

export default dlKraken;
