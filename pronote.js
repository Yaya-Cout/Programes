const pronote = require('pronote-api');

// Exemple
const url = 'https://exemple.com';
const username = 'username';
const password = 'password';

async function main() {
    const session = await pronote.login(url, username, password, 'toutatice');

    console.log(session.user.name); // Affiche le nom de l'élève
    console.log(session.user.studentClass.name); // Affiche la classe de l'élève

    const timetable = await session.timetable(); // Récupérer l'emploi du temps d'aujourd'hui
    const marks = await session.marks(); // Récupérer les notes du trimestre

    console.log(`L'élève a ${timetable.length} cours aujourd'hui`);
    console.log(`et a pour l'instant une moyenne de ${marks.averages.student} ce trimestre.`);

    // etc. les fonctions utilisables sont 'timetable', 'marks', 'contents', 'evaluations', 'absences',
    // 'homeworks', 'infos', et 'menu', sans oublier les champs 'user' et 'params' qui regorgent d'informations.
}

main().catch(err => {
    if (err.code === pronote.errors.WRONG_CREDENTIALS.code) {
        console.error('Mauvais identifiants');
    } else {
        console.error(err);
    }
});