#!/usr/bin/env bash


BASE="$(dirname "$(readlink -f "${BASH_SOURCE:-0}")")"
DIRNAME="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)"
FILENAME="$(basename "${BASH_SOURCE:-0}")"
DATEID=$(date +%Y%m%d%H%M%S)
NOW=$(date +'%Y-%m-%d %H:%M:%S.%N')


## Build Option
BUILD_HTML=0
readonly DRYRUN=false


echo "-> STEP1 INITIALIZE"
echo "$(date +'%Y-%m-%d %H:%M:%S.%N')"
TMP="$BASE/tmp"
TARGET_TEXT="${TMP}/target.txt"
echo "BASE:$BASE"
echo "TMP:$TMP"
if [[ -d "${TMP}" && ! -L "${TMP}" ]] ; then
  echo "FOUND TMP";
else
  echo "NOT FOUND TMP";
  mkdir -p $TMP
fi


echo "-> STEP2 SEARCH"
TARGET="$BASE"
OUTPUT_FILE="packaged.sh"
OUTPUT="${TARGET}/${OUTPUT_FILE}"
LIST=()
ITEMS=()
echo "TARGET:$TARGET"
echo "OUTPUT_FILE:$OUTPUT_FILE"
echo "OUTPUT:$OUTPUT"
FIND_RESULT=`
\find ${TARGET} -type f \
	-not -path "*.swp" \
 	-and -not -path "*/.git/*" \
 	-and -not -path "*/.ssh/known_hosts" \
 	-and -not -path "*/vendor/*" \
 	-and -not -path "*/node_modules/*" \
 	-and -not -path "${TMP}/*" \
 	-and -not -path "${OUTPUT}" \
 	-and -not -path "${TARGET}/sandbox/*" \
 	-or -path "${TARGET}/io/receiver.sh" \
 	-or -path "${TARGET}/io/sender.sh" \
 	-or -path "${TARGET}/sandbox/.gitkeep"
`;
for FILEPATH in $FIND_RESULT; do
  _D="$(dirname ${FILEPATH#$TARGET/})"
  _F="${FILEPATH##*/}"
  if [ "$(uname)" == 'Darwin' ]; then
    _P=$(stat -L -f "%A" ${FILEPATH})
  else
    _P=$(stat -L -c "%a" ${FILEPATH})
  fi
  if "${DRYRUN}"; then
    echo "${_D}/${_F}"
  else
    LIST+=("$_D/$_F")
    ## associative array -> bash array is string list only
    ITEMS+=("${_D} ${_F} ${_P}")
  fi
done
if "${DRYRUN}"; then
  return 2> /dev/null; exit
fi 


echo "-> STEP3 FILTER"
MERGE_CMD=""
IDX=1
for ITEM in "${ITEMS[@]}"; do
  E=(${ITEM[@]})
  D=${E[0]};
  F=${E[1]};
  P=${E[2]};
  MERGE_CMD+=" ${TMP}/${D}/${F}"
  #echo "[$IDX] DIR:${D},FILE:${F},PERMISSION:${P}";
  printf "[%04d] ${D}/${F} (${P})\n" "${IDX}"
  MKDIR="$TMP/$D";
cmd=$(cat <<EOL
mkdir -p $MKDIR
echo "++++++++++++++" > $MKDIR/$F
echo "DIR:${D}" >> $MKDIR/$F
echo "FILE:${F}" >> $MKDIR/$F
echo "PERMISSION:${P}" >> $MKDIR/$F
echo "==============" >> $MKDIR/$F
echo "\`cat ${TARGET}/${D}/${F}\`" >> $MKDIR/$F
echo "--------------" >> $MKDIR/$F
chmod $P $MKDIR/$F
EOL
)
  while read -a arr; do
    #echo "${arr[*]}"
    eval ${arr[*]}
  done < <(echo "$cmd")
  let IDX++
done


echo "-> STEP4 TARGET MERGE"
MERGE_CMD="cat ${MERGE_CMD} > ${TARGET_TEXT}"
#echo $MERGE_CMD
eval $MERGE_CMD
#find $TMP -type f -print0 | xargs -0 more | cat > ${TARGET_TEXT}


echo "-> STEP5 HEAD MERGE"
HEADER="##############"
HEAD="$TMP/head.sh"
HEAD_FLG=0
echo -n "" > ${HEAD}
while IFS= read -r arr; do
  LINE="${arr[*]}"
  if [[ "$HEAD_FLG" == "1" ]]; then
    echo "$LINE" >> ${HEAD}
  else
    if [[ "$HEADER" == "$LINE" ]]; then
      HEAD_FLG=1
    fi
  fi
done < <(cat "${DIRNAME}/${FILENAME}")


echo "-> STEP6 SYSTEM MERGE"
cat ${HEAD} ${TARGET_TEXT} > ${OUTPUT}
chmod +x ${OUTPUT}


echo "-> STEP7 GENERATE HTML"
if [[ "$BUILD_HTML" == "0" ]]; then
 echo "SKIP"
else
HTML=$BASE/index.html
bash -c "cat << 'EOF' > $HTML
<html>
<head>
<meta charset="utf-8"></head>
<body>
<a href="f.sh">f.sh</a>
<hr/>
<code>
EOF"
cat $OUTPUT >> $HTML
bash -c "cat << 'EOF' >> $HTML
</code>
</body>
</html>
EOF"
fi


echo "-> CLEANUP"
## first, delete file only
find $TMP -type f | xargs rm -f
## second, delete directory (no force option)
rm -R $TMP;


echo "-> COMPLETE"
echo "$(date +'%Y-%m-%d %H:%M:%S.%N')"
return 2> /dev/null; exit


##############
#!/usr/bin/env bash

BASE="$(dirname "$(readlink -f "${BASH_SOURCE:-0}")")"
DIRNAME="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)"
FILENAME="$(basename "${BASH_SOURCE:-0}")"
DATEID=$(date +%Y%m%d%H%M%S)


echo "-> PHASE1"
echo "PATH:$DIRNAME/$FILENAME"
EXPORT="${BASE}"


echo "-> PHASE2"
NO=1
MODE=0 # 0:default, 1:setting, 2:body, 3:permission
START="::::::::::::::"
FIRST="++++++++++++++"
MIDDLE="=============="
LAST="--------------"
while IFS= read -r arr; do
  LINE="${arr[*]}"
  #echo "$LINE"
  case $MODE in
    0)
      if [[ "$START" == "$LINE" ]]; then
        #echo "-> START"
        MODE=1
      fi
    ;;
    1)
      DIR=""
      FILE=""
      PERMISSION=""
      if [[ "$FIRST" == "$LINE" ]]; then
        #echo "-> FIRST"
        MODE=2
      fi
    ;;
    2)
      if [[ "$MIDDLE" == "$LINE" ]]; then
        #echo "-> MIDDLE"
        mkdir -p "${EXPORT}/${DIR}"
        echo -n "" > "${EXPORT}/${DIR}/${FILE}"
        MODE=3
      else
        KEY="${LINE%:*}"
        VAL="${LINE##*:}"
        #echo "${KEY}:${VAL}"
        case $KEY in
          "DIR") DIR=$VAL;;
          "FILE") FILE=$VAL;;
          "PERMISSION") PERMISSION=$VAL;;
          *) echo "WARNING:PARAMETOR";;
        esac
      fi
    ;;
    3)
      if [[ "$LAST" == "$LINE" ]]; then
        #echo "-> LAST"
        #echo "DIR:${DIR},FILE:${FILE},PERMISSION:${PERMISSION}";
        printf "[%04d] ${DIR}/${FILE} (${PERMISSION})\n" "${NO}"
        chmod ${PERMISSION} "${EXPORT}/${DIR}/${FILE}"
        MODE=1
        let NO++
      else
        if [ -z "$DIR" ] || [ -z "$FILE" ] || [ -z "$PERMISSION" ]; then
          echo "> ERROR PARAM"
          echo "DIR:${DIR}"
          echo "FILE:${FILE}"
          echo "PERMISSION:${PERMISSION}"
          return 2> /dev/null; exit
        fi
        #echo "-> BODY(${EXPORT}/${DIR}/${FILE})"
        mkdir -p ${EXPORT}/${DIR}
        echo "$LINE" >> "${EXPORT}/${DIR}/${FILE}"
      fi
    ;;
    *)
      # MODE ERROR
      MODE=0
    ;;
  esac
done < <(cat "${DIRNAME}/${FILENAME}")


echo "-> COMPLETE"
## For return–and-exit (source X.sh && ./X.sh)
return 2> /dev/null; exit
## Safety
while true; do
  echo "SAFETY"
  read INPUT
  case  in
    *) ;;
  esac
done
::::::::::::::
