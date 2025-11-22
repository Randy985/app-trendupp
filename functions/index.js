const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const axios = require("axios");

const openaiKey = defineSecret("OPENAI_KEY");

const USER_PROMPT = (topic) => `
Genera una idea viral y muy fácil de entender para un video sobre: "${topic}".
Usa lenguaje totalmente simple, natural y latino. 
No uses palabras técnicas, no uses términos de cine, no uses palabras como: plano, escena, transición, toma, cámara fija, corte, slow motion, efectos, profesional, técnico, dramatizado, teatral, over the top.

La idea debe sonar como algo que un amigo le diría a otro.

Reglas:
• Idea corta y directa.
• Máximo 3-4 pasos fáciles.
• Que sea divertida o sorprendente.
• Que cualquier persona la pueda grabar en su casa.
• Hashtags latinos actuales.
• Música: solo describe el estilo, nada más.

Formato EXACTO:

🎬 Idea:
📹 Qué hacer (paso a paso):
🔖 Hashtags recomendados:
🎵 Música sugerida:
`;

exports.generateIdea = onCall({ secrets: [openaiKey] }, async (request) => {
  const data = request.data;

  const topic =
    typeof data === "string"
      ? data
      : data?.topic || data?.text || data?.prompt || null;

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
              "Generas ideas virales claras, atractivas y fáciles de grabar para TikTok, Reels y Shorts.",
          },
          {
            role: "user",
            content: USER_PROMPT(topic),
          },
        ],
      },
      {
        headers: {
          Authorization: `Bearer ${openaiKey.value()}`,
          "Content-Type": "application/json",
        },
      }
    );

    const text =
      response.data?.choices?.[0]?.message?.content || "Sin respuesta";

    return { result: text };
  } catch (error) {
    throw new Error("Error generando la idea con OpenAI");
  }
});
