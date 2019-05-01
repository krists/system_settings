import React from 'react'
import PropTypes from "prop-types";
import style from "./ClassicSpinner.module.scss"

export class ClassicSpinner extends React.Component {
  render(){
    let { size, color, title, wrapperStyle, ...rest } = this.props;
    return (
      <span className={style["wrap"]} style={{...wrapperStyle, width: size, height: size}}>
        <svg xmlns="http://www.w3.org/2000/svg" {...rest} width={size} height={size} viewBox="0 0 64 64" fill="none" stroke={color} aria-labelledby="title">
          <title id="title">{title}</title>
          <g strokeWidth="4" strokeLinecap="round">
            <line y1="12" y2="20" transform="translate(32,32) rotate(180)">
              <animate attributeName="stroke-opacity" dur="750ms" values="1;.85;.7;.65;.55;.45;.35;.25;.15;.1;0;1" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(210)">
              <animate attributeName="stroke-opacity" dur="750ms" values="0;1;.85;.7;.65;.55;.45;.35;.25;.15;.1;0" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(240)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".1;0;1;.85;.7;.65;.55;.45;.35;.25;.15;.1" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(270)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".15;.1;0;1;.85;.7;.65;.55;.45;.35;.25;.15" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(300)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".25;.15;.1;0;1;.85;.7;.65;.55;.45;.35;.25" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(330)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".35;.25;.15;.1;0;1;.85;.7;.65;.55;.45;.35" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(0)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".45;.35;.25;.15;.1;0;1;.85;.7;.65;.55;.45" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(30)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".55;.45;.35;.25;.15;.1;0;1;.85;.7;.65;.55" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(60)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".65;.55;.45;.35;.25;.15;.1;0;1;.85;.7;.65" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(90)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".7;.65;.55;.45;.35;.25;.15;.1;0;1;.85;.7" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(120)">
              <animate attributeName="stroke-opacity" dur="750ms" values=".85;.7;.65;.55;.45;.35;.25;.15;.1;0;1;.85" repeatCount="indefinite"></animate>
            </line>
            <line y1="12" y2="20" transform="translate(32,32) rotate(150)">
              <animate attributeName="stroke-opacity" dur="750ms" values="1;.85;.7;.65;.55;.45;.35;.25;.15;.1;0;1" repeatCount="indefinite"></animate>
            </line>
          </g>
        </svg>
      </span>
    )
  }
}

ClassicSpinner.propTypes = {
  size: PropTypes.string.isRequired,
  color: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
};

ClassicSpinner.defaultProps = {
  color: "currentColor",
  size: "1rem",
  title: "Loading…"
};

export default ClassicSpinner;
