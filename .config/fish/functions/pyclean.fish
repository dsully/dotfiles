function pyclean
    command git clean -e config/ -e i18n/ -e .idea/ -e .gradle/ -e gradle/ -e *.iml -e *.ipr -e *.iws -e *.ipr -xdf
end
