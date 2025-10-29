const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const axios = require("axios");

const openaiKey = defineSecret("OPENAI_KEY");

exports.generateIdea = onCall({ secrets: [openaiKey] }, async (request) => {
    const data = request.data;
    const topic =
        typeof data === "string"
            ? data
            : data?.topic || data?.text || data?.prompt || null;

    console.log("📩 Datos recibidos:", data);
    console.log("📌 Tópico detectado:", topic);

    if (!topic || topic.trim() === "") {
        throw new Error("Topic missing");
    }

    try {
        const response = await axios.post(
            "https://api.openai.com/v1/chat/completions",
            {
                model: "gpt-5-mini",
                messages: [
                    {
                        role: "system",
                        content:
                            "Eres un generador de ideas creativas para videos virales en TikTok, Reels o Shorts.",
                    },
                    {
                        role: "user",
                        content: `Genera una idea original, divertida y viral para un video corto sobre el tema: "${topic}".
            El contenido debe ser fácil de grabar con un teléfono, atractivo en los primeros segundos y tener un toque emocional o cómico.

            Responde exactamente con el siguiente formato:

            🎬 Idea:
            📹 Qué hacer (paso a paso):
            🔖 Hashtags recomendados:
            🎵 Música sugerida (popular o con buen ritmo para reels/tiktok):
            `
                    }

                ],
            },
            {
                headers: {
                    Authorization: `Bearer ${openaiKey.value()}`,
                    "Content-Type": "application/json",
                },
            }
        );

        const text = response.data.choices?.[0]?.message?.content || "Sin respuesta";
        console.log("✅ Respuesta OpenAI:", text);
        return { result: text };
    } catch (error) {
        console.error("🔥 Error:", error.response?.data || error);
        throw new Error("Error generando la idea con OpenAI");
    }
});
