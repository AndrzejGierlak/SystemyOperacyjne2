#!/bin/bash -eu

#+ 0.5: Dotyczy opcji ‘-f’: jeżeli plik podany przez użytkownika nie posiada rozszerzenia '.txt' dodaj je -DONE
# + 1.0: Dodaj opcję -y ROK: wyszuka wszystkie filmy nowsze niż ROK. Pamiętaj o dodaniu opisu do -h -DONE
#+ 1.0: Dodaj wyszukiwanie po polu z fabułą, za pomocą wyrażenia regularnego. Np. -R 'Cap.*Amer' Jeżeli dodatkowo podamy parametr '-i' to ignoruje wielkość liter -DONE
#
#+ 0.5: Dodaj sprawdzenie, czy na pewno wykorzystano opcję '-d' i czy jest to katalog -50-50
#+1.0:  Dokończ funkcję “print_xml_format”
#+ 1.0: shellcheck nie krzyczy. Unikamy "disable" -probably DONE?



function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
    echo -e "-y Year\n\tSearch movies from selected year"
    echo -e "-p Plot\n\tSearch movies containg chosen regex\n\t\t add -i to use case insensitive search"
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    if [[ -d "${MOVIES_DIR}" ]];then
        #echo "${MOVIES_DIR}exists on your filesystem."
        local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath *)
        echo "${MOVIES_LIST}"
    #else
       : #echo "${MOVIES_DIR} doesnt exist on your filesystem."
    fi


}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE} ")
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {
    # Returns list of movies from ${1} with ${2} in year slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Year" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE} ")
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_plot () {
    # Returns list of movies from ${1} with ${2} in year slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if ${IGNORE_CAPITALS:-false}; then
            if grep "| Plot" "${MOVIE_FILE}" | grep -iq "${QUERY}"; then
                RESULTS_LIST+=( "${MOVIE_FILE} ")
            fi
        else
            if grep "| Plot" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
                RESULTS_LIST+=( "${MOVIE_FILE} ")
            fi
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP
    TEMP=$(cat "${FILENAME}")

    # TODO: replace first line of equals signs

    # TODO: change 'Author:' into <Author>
    # TODO: change others too

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=$(echo "${1}")
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

ANY_ERRORS=false

while getopts ":hd:t:a:y:p:if:x" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    f)
        if [[ "${OPTARG: -4}" == ".txt" ]] ; then
            FILE_4_SAVING_RESULTS=${OPTARG}
        else
            FILE_4_SAVING_RESULTS="${OPTARG}.txt"
        fi
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=$( echo "${OPTARG}")
        ;;
    y)  SEARCHING_YEAR=true
        QUERY_YEAR=$( echo "${OPTARG}")
        ;;
    p)  SEARCHING_PLOT=true
        QUERY_PLOT=$( echo "${OPTARG}")
        ;;
    i)  IGNORE_CAPITALS=true
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        ANY_ERRORS=true
        exit 1
        ;;
  esac
done

if [[ -z "${MOVIES_DIR+x}" ]] ; then
echo "No directory selected"
else
    if [[ -d "${MOVIES_DIR}" ]];
    then
        #echo "${MOVIES_DIR} exists on your filesystem."
        :

        MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

        if ${SEARCHING_TITLE:-false}; then
            MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
        fi

        if ${SEARCHING_ACTOR:-false}; then
            MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
        fi

        if ${SEARCHING_YEAR:-false}; then
            MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
        fi

        if ${SEARCHING_PLOT:-false}; then
            MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}")
        fi

        if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
            echo "Found 0 movies :-("
            exit 0
        fi

        if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
            print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
        else
            # TODO: add XML option
            print_movies "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
        fi

    else
        echo "Incorrect directory."
    fi
fi